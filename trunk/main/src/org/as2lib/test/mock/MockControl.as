/**
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.env.reflect.ProxyFactory;
import org.as2lib.env.reflect.ResolveProxyFactory;
import org.as2lib.env.reflect.InvocationHandler;
import org.as2lib.test.mock.ArgumentsMatcher;
import org.as2lib.test.mock.support.DefaultArgumentsMatcher;
import org.as2lib.test.mock.support.TypeArgumentsMatcher;
import org.as2lib.test.mock.MethodBehavior;
import org.as2lib.test.mock.Behavior;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.support.DefaultBehavior;
import org.as2lib.test.mock.MockControlState;
import org.as2lib.test.mock.support.RecordState;
import org.as2lib.test.mock.support.ReplayState;
import org.as2lib.test.mock.MockControlStateFactory;

/**
 * The MockControl is the central class of the mock object framework.
 * You use it to create your mock object, set expectations and verify
 * whether this expectations have been met.
 *
 * <p>The normal workflow is creating a mock control for a specific class
 * or interface, receiving the mock object from it, setting expectations,
 * setting the behavior of the mock object, switching to replay state,
 * using the mock object as if it were a normal instance of a class and
 * verifying that all expectations have been met.
 *
 * <code>
 * import org.as2lib.test.mock.MockControl;
 *
 * // create mock control for class MyClass
 * var myMockControl:MockControl = new MockControl(MyClass);
 * // receive the mock object (it is in record state)
 * var myMock:MyClass = myMockControl.getMock();
 * // expect a call to the setStringProperty-method with argument 'myString'.
 * myMock.setStringProperty("myString");
 * // expect calls to the getStringProperty-method
 * myMock.getStringProperty();
 * // return 'myString' for the first two calls
 * myMockControl.setReturnValue("myString", 2);
 * // throw MyException for any further call
 * myMockControl.setDefaultThrowable(new MyException());
 * // switch to replay state
 * myMockControl.replay();
 *
 * // the class under test calls these methods on the mock
 * myMock.setStringProperty("myString");
 * myMock.getStringProperty();
 * myMock.getStringProperty();
 *
 * // verify that alle expectations have been met
 * myMockControl.verify();
 * </code>
 *
 * If a expectation has not been met a AssertionFailedError will
 * be thrown. 
 * If a expectation violation gets discovered during execution
 * an AssertionFailedError will be thrown immediately.
 *
 * @author Simon Wacker
 */
class org.as2lib.test.mock.MockControl extends BasicClass {
	
	/** Stores the type of the mock proxy. */
	private var type:Function;
	
	/** Used to create a new mock proxy. */
	private var proxyFactory:ProxyFactory;
	
	/** Stores the created mock proxy. */
	private var mock;
	
	/** Stores the mock behavior. */
	private var behavior:Behavior;
	
	/** Stores the state. */
	private var state:MockControlState;
	
	/** Factory used to obtain the record state. */
	private var recordStateFactory:MockControlStateFactory;
	
	/** Factory used to obtain the replay state. */
	private var replayStateFactory:MockControlStateFactory;
	
	/**
	 * Returns a default arguments matcher.
	 *
	 * @return a default arguments matcher
	 */
	public static function getDefaultArgumentsMatcher(Void):DefaultArgumentsMatcher {
		return new DefaultArgumentsMatcher();
	}
	
	/**
	 * Returns a type arguments matcher.
	 * 
	 * <p>Type arguments matcher match arguments by type and not by value.
	 *
	 * @return a type arguments matcher
	 */
	public static function getTypeArgumentsMatcher(expectedTypes:Array):TypeArgumentsMatcher {
		return new TypeArgumentsMatcher(expectedTypes);
	}
	
	/**
	 * @overload #MockControlByType(Function)
	 * @overload #MockControlByTypeAndBehavior(Function, Behavior)
	 */
	public function MockControl() {
		var o:Overload = new Overload(this);
		o.addHandler([Function], MockControlByType);
		o.addHandler([Function, Behavior], MockControlByTypeAndBehavior);
		o.forward(arguments);
	}
	
	/**
	 * Constrcuts a new instance using the default behavior.
	 *
	 * <p>The default behavior is an instance of class DefaultBehaviour.
	 *
	 * @param type the interface or class to create a mock object for
	 */
	private function MockControlByType(type:Function) {
		MockControlByTypeAndBehavior(type, new DefaultBehavior());
	}
	
	/**
	 * Constructs a new instance.
	 *
	 * @param type the interface or class to create a mock object for
	 * @param behavior the instance to store the behavior of the mock
	 */
	private function MockControlByTypeAndBehavior(type:Function, behavior:Behavior):Void {
		this.type = type;
		this.behavior = behavior;
		reset();
	}
	
	/**
	 * Returns the currently used proxy factory.
	 *
	 * <p>This proxy factoy is either the default ResolveProxyFactory
	 * or the one set via #setMockProxyFactory(ProxyFactory):Void.
	 *
	 * @return the currently used proxy factory
	 * @see #setMockProxyFactory(ProxyFactory):Void
	 */
	public function getMockProxyFactory(Void):ProxyFactory {
		if (!proxyFactory) proxyFactory = new ResolveProxyFactory();
		return proxyFactory;
	}
	
	/**
	 * Sets the proxy factory used to obtain the mock proxy.
	 *
	 * <p>If you set a proxy factory of null or undefined, the
	 * #getMockProxyFactory(Void):ProxyFactory method will use the
	 * default one.
	 *
	 * @param proxyFactory factory to obtain mock proxies
	 * @see #getMockProxyFactory(Void):ProxyFactory
	 */
	public function setMockProxyFactory(proxyFactory:ProxyFactory):Void {
		this.proxyFactory = proxyFactory;
	}
	
	/**
	 * Returns the currently used record state factory.
	 *
	 * <p>This is either the factory set via #setRecordStateFactory(MockControlStateFactory):Void
	 * or the default one, which returns an instance of the RecordState class.
	 *
	 * @return the currently used record state factory
	 * @see #setRecordStateFactory(MockControlStateFactory):Void
	 */
	public function getRecordStateFactory(Void):MockControlStateFactory {
		if (!recordStateFactory) recordStateFactory = getDefaultRecordStateFactory();
		return recordStateFactory;
	}
	
	/**
	 * @return the default record state factory
	 */
	private function getDefaultRecordStateFactory(Void):MockControlStateFactory {
		var result:MockControlStateFactory = new MockControlStateFactory();
		result.getMockControlState = function(behavior:Behavior):MockControlState {
			return new RecordState(behavior);
		}
		return result;
	}
	
	/**
	 * Sets the new record state factory to be used.
	 *
	 * <p>If you set a factory of value null or undefined the default record
	 * state factory gets returned by the #getRecordStateFactory(Void):MockControlStateFactory
	 * method.
	 *
	 * @param recordStateFactory the new record state factory
	 * @see #getRecordStateFactory(Void):MockControlStateFactory
	 */
	public function setRecordStateFactory(recordStateFactory:MockControlStateFactory):Void {
		this.recordStateFactory = recordStateFactory;
	}
	
	/**
	 * Returns the currently used replay state factory.
	 *
	 * <p>This is either the factory set via #setReplayStateFactory(MockControlStateFactory):Void
	 * or the default one, which returns an instance of the ReplayState class.
	 *
	 * @return the currently used replay state factory
	 * @see #setReplayStateFactory(MockControlStateFactory):Void
	 */
	public function getReplayStateFactory(Void):MockControlStateFactory {
		if (!replayStateFactory) replayStateFactory = getDefaultReplayStateFactory();
		return replayStateFactory;
	}
	
	/**
	 * @return the default replay state factory
	 */
	private function getDefaultReplayStateFactory(Void):MockControlStateFactory {
		var result:MockControlStateFactory = new MockControlStateFactory();
		result.getMockControlState = function(behavior:Behavior):MockControlState {
			return new ReplayState(behavior);
		}
		return result;
	}
	
	/**
	 * Sets the new replay state factory to be used.
	 *
	 * <p>If you set a factory of value null or undefined, #getReplayStateFactory(Void):MockControlStateFactory
	 * will return the default replay state factory.
	 *
	 * @param replayStateFactory the new replay state factory
	 * @see #getReplayStateFactory(Void):MockControlStateFactory
	 */
	public function setReplayStateFactory(replayStateFactory:MockControlStateFactory):Void {
		this.replayStateFactory = replayStateFactory;
	}
	
	/**
	 * Returns the mock object.
	 *
	 * <p>It can be casted to the interface defined during instantiation.
	 *
	 * @return the mock object
	 */
	public function getMock(Void) {
		if (!mock) mock = getMockProxyFactory().createProxy(type, createDelegator());
		return mock;
	}
	
	/**
	 * Creates a new invocation handler instance that handles method
	 * invocations on the proxy.
	 *
	 * @return a delegator that handles proxy method invocations
	 */
	private function createDelegator(Void):InvocationHandler {
		var result:InvocationHandler = new InvocationHandler();
		var owner:MockControl = this;
		result.invoke = function(proxy, method:String, args:Array) {
			return owner.invokeMethod(method, args);
		}
		return result;
	}
	
	/**
	 * Gets called when a method gets invoked on the proxy.
	 *
	 * @param methodName the name of the invoked method
	 * @param args the arguments passed to the invoked method
	 */
	private function invokeMethod(methodName:String, args:Array) {
		return state.invokeMethod(new MethodCall(methodName, args));
	}
	
	/**
	 * Switches the mock object from record state to replay state.
	 *
	 * <p>The mock object is in record state as soon as it gets returned by
	 * the #getMock(Void) method.
	 */
	public function replay(Void):Void {
		state = getReplayStateFactory().getMockControlState(behavior);
	}
	
	/**
	 * Resets the mock control and the mock object to the state directly after
	 * creation. That means that all previously made configurations will be
	 * removed and that the mock object will again be in record state.
	 */
	public function reset(Void):Void {
		behavior.removeAllBehavior();
		state = getRecordStateFactory().getMockControlState(behavior);
	}
	
	/**
	 * Sets the arguments matcher that will be used for the last method specified
	 * by a method call.
	 *
	 * @param argumentsMatcher the arguments matcher to use for the specific method
	 */
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void {
		state.setArgumentsMatcher(argumentsMatcher);
	}
	
	/**
	 * Records that the mock object will by default allow the last method specified
	 * by a method call and will react by returning the provided return value.
	 *
	 * @param value the return value to return
	 */
	public function setDefaultReturnValue(value):Void {
		var response:MethodResponse = new MethodResponse();
		response.setReturnValue(value);
		state.setMethodResponse(response, new MethodCallRange());
	}
	
	/**
	 * Records that the mock object will by default allow the last method specified 
	 * by a method call, and will react by throwing the provided throwable.
	 *
	 * @param throwable the throwable to throw
	 */
	public function setDefaultThrowable(throwable):Void {
		var response:MethodResponse = new MethodResponse();
		response.setThrowable(throwable);
		state.setMethodResponse(response, new MethodCallRange());
	}
	
	/**
	 * Recards that the mock object will by default allow the last method specified
	 * by a method call.
	 */
	public function setDefaultVoidCallable(Void):Void {
		state.setMethodResponse(new MethodResponse(), new MethodCallRange());
	}
	
	/**
	 * @overload #setReturnValueByValue(*)
	 * @overload #setReturnValueByValueAndQuantity(*, Number)
	 * @overload #setReturnValueByValueAndMinimumAndMaximumQuantity(*, Number, Number)
	 */
	public function setReturnValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Object], setReturnValueByValue);
		o.addHandler([Object, Number], setReturnValueByValueAndQuantity);
		o.addHandler([Object, Number, Number], setReturnValueByValueAndMinimumAndMaximumQuantity);
		o.forward(arguments);
	}
	
	/**
	 * Records that the mock object will expect the last method call once and will
	 * react by returning the provided return value.
	 *
	 * @param value the return value to return
	 */
	public function setReturnValueByValue(value):Void {
		setReturnValueByValueAndQuantity(value, 1);
	}
	
	/**
	 * Records that the mock object will expect the last method call a fixed number
	 * of times and will react by returning the provided return value.
	 *
	 * @param value the return value to return
	 * @param quantity the number of times the method is allowed to be invoked
	 */
	public function setReturnValueByValueAndQuantity(value, quantity:Number):Void {
		var response:MethodResponse = new MethodResponse();
		response.setReturnValue(value);
		state.setMethodResponse(response, new MethodCallRange(quantity));
	}
	
	/**
	 * Records that the mock object will expect the last method call between minimumQuantity
	 * and maximumQuantity times and will react by returning the provided return value.
	 *
	 * @param value the return value to return
	 * @param minimumQuantity the minimum number of times the method must be called
	 * @param maximumQuantity the maximum number of times the method can be called
	 */
	public function setReturnValueByValueAndMinimumAndMaximumQuantity(value, minimumQuantity:Number, maximumQuantity:Number):Void {
		var response:MethodResponse = new MethodResponse();
		response.setReturnValue(value);
		state.setMethodResponse(response, new MethodCallRange(minimumQuantity, maximumQuantity));
	}
	
	/**
	 * @overload #setThrowableByThrowable(*)
	 * @overload #setThrowableByThrowableAndQuantity(*, Number)
	 * @overload #setThrowableByThrowableAndMinimumAndMaximumQuantity(*, Number, Number)
	 */
	public function setThrowable():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Object], setThrowableByThrowable);
		o.addHandler([Object, Number], setThrowableByThrowableAndQuantity);
		o.addHandler([Object, Number, Number], setThrowableByThrowableAndMinimumAndMaximumQuantity);
		o.forward(arguments);
	}
	
	/**
	 * Records that the mock object will expect the last method call once and will 
	 * react by throwing the provided throwable.
	 *
	 * @param throwable the throwable to throw
	 */
	public function setThrowableByThrowable(throwable):Void {
		setThrowableByThrowableAndQuantity(throwable, 1);
	}
	
	/**
	 * Records that the mock object will expect the last method call a fixed number 
	 * of times and will react by throwing the provided throwable.
	 *
	 * @param throwable the throwable to throw
	 * @param quantity the number of times the method is allowed to be invoked
	 */
	public function setThrowableByThrowableAndQuantity(throwable, quantity:Number):Void {
		var response:MethodResponse = new MethodResponse();
		response.setThrowable(throwable);
		state.setMethodResponse(response, new MethodCallRange(quantity));
	}
	
	/**
	 * Records that the mock object will expect the last method call between minimumQuantity 
	 * and maximumQuantity times, and will react by throwing the provided throwable.
	 *
	 * @param throwable the throwable to throw
	 * @param minimumQuantity the minimum number of times the method must be called
	 * @param maximumQuantity the maximum number of times the method can be called
	 */
	public function setThrowableByThrowableAndMinimumAndMaximumQuantity(throwable, minimumQuantity:Number, maximumQuantity:Number):Void {
		var response:MethodResponse = new MethodResponse();
		response.setThrowable(throwable);
		state.setMethodResponse(response, new MethodCallRange(minimumQuantity, maximumQuantity));
	}
	
	/**
	 * @overload #setVoidCallableByVoid(Void)
	 * @overload #setVoidCallableByQuantity(Number)
	 * @overload #setVoidCallableByMinimumAndMaximumQuantity(Number, Number)
	 */
	public function setVoidCallable():Void {
		var o:Overload = new Overload(this);
		o.addHandler([], setVoidCallableByVoid);
		o.addHandler([Number], setVoidCallableByQuantity);
		o.addHandler([Number, Number], setVoidCallableByMinimumAndMaximumQuantity);
		o.forward(arguments);
	}
	
	/**
	 * Records that the mock object will expect the last method call once and will 
	 * react by returning silently.
	 */
	public function setVoidCallableByVoid(Void):Void {
		setVoidCallableByQuantity(1);
	}
	
	/**
	 * Records that the mock object will expect the last method call a fixed number 
	 * of times and will react by returning silently.
	 *
	 * @param quantity the number of times the method is allowed to be invoked
	 */
	public function setVoidCallableByQuantity(quantity:Number):Void {
		state.setMethodResponse(new MethodResponse(), new MethodCallRange(quantity));
	}
	
	/**
	 * Records that the mock object will expect the last method call between minimumQuantity 
	 * and maximumQuantity times and will react by returning silently.
	 *
	 * @param minimumQuantity the minimum number of times the method must be called
	 * @param maximumQuantity the maximum number of times the method can be called
	 */
	public function setVoidCallableByMinimumAndMaximumQuantity(minimumQuantity:Number, maximumQuantity:Number):Void {
		state.setMethodResponse(new MethodResponse(), new MethodCallRange(minimumQuantity, maximumQuantity));
	}
	
	/**
	 * Verifies that all expectations have been met.
	 *
	 * <p>If an expectation has not been met an AssertionFailedError will be 
	 * thrown.
	 */
	public function verify(Void):Void {
		state.verify();
	}
	
}