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
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MockControl;
import org.as2lib.test.mock.ArgumentsMatcher;
import org.as2lib.test.mock.MethodCallBehaviour;
import org.as2lib.test.mock.Behaviour;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.support.DefaultBehaviour;
import org.as2lib.test.mock.MockControlState;
import org.as2lib.test.mock.support.RecordState;
import org.as2lib.test.mock.support.ReplayState;
import org.as2lib.test.mock.MockControlStateFactory;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.SimpleMockControl extends BasicClass implements MockControl {
	
	/** Stores the type of the mock proxy. */
	private var type:Function;
	
	/** Used to create a new mock proxy. */
	private var proxyFactory:ProxyFactory;
	
	/** Stores the created mock proxy. */
	private var mock;
	
	/** Stores the mock behaviours. */
	private var behaviour:Behaviour;
	
	/** Stores the state. */
	private var state:MockControlState;
	
	/** Factory used to obtain the record state. */
	private var recordStateFactory:MockControlStateFactory;
	
	/** Factory used to obtain the replay state. */
	private var replayStateFactory:MockControlStateFactory;
	
	/**
	 * @overload #SimpleMockControlByType()
	 * @overload #SimpleMockControlByTypeAndBehaviour()
	 */
	public function SimpleMockControl() {
		var o:Overload = new Overload(this);
		o.addHandler([Function], SimpleMockControlByType);
		o.addHandler([Function, Behaviour], SimpleMockControlByTypeAndBehaviour);
		o.forward(arguments);
	}
	
	/**
	 * Constrcuts a new instance using the default behaviour.
	 *
	 * @param type the interface or class to create a mock object for
	 */
	private function SimpleMockControlByType(type:Function) {
		SimpleMockControlByTypeAndBehaviour(type, new DefaultBehaviour());
	}
	
	/**
	 * Constructs a new instance.
	 *
	 * @param type the interface or class to create a mock object for
	 * @param behaviour the instance to store the behaviour of the mock inside
	 */
	private function SimpleMockControlByTypeAndBehaviour(type:Function, behaviour:Behaviour):Void {
		this.type = type;
		this.behaviour = behaviour;
		reset();
	}
	
	/**
	 * Returns the currently used ProxyFactory. This is either the default
	 * ResolveProxyFactory or the one set vie #setMockProxyFactory().
	 *
	 * @return the currently used ProxyFactory
	 */
	public function getMockProxyFactory(Void):ProxyFactory {
		if (!proxyFactory) proxyFactory = new ResolveProxyFactory();
		return proxyFactory;
	}
	
	/**
	 * Sets the ProxyFactory used to obtain the mock proxy.
	 *
	 * @param proxyFactory factory to obtain mock proxies
	 */
	public function setMockProxyFactory(proxyFactory:ProxyFactory):Void {
		this.proxyFactory = proxyFactory;
	}
	
	/**
	 * Returns either the factory set via #setRecordStateFactory() or the
	 * default one. The record state factory gets used to obtain the record state.
	 *
	 * @return the currently used record state factory
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
		result.getMockControlState = function(behaviour:Behaviour):MockControlState {
			return new RecordState(behaviour);
		}
		return result;
	}
	
	/**
	 * Sets the new record state factory to be used.
	 *
	 * @param recordStateFactory the new record state factory
	 */
	public function setRecordStateFactory(recordStateFactory:MockControlStateFactory):Void {
		this.recordStateFactory = recordStateFactory;
	}
	
	/**
	 * Returns either the factory set via #setReplayStateFactory() or the
	 * default one. The record state factory gets used to obtain the replay state.
	 *
	 * @return the currently used replay state factory
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
		result.getMockControlState = function(behaviour:Behaviour):MockControlState {
			return new ReplayState(behaviour);
		}
		return result;
	}
	
	/**
	 * Sets the new replay state factory to be used.
	 *
	 * @param replayStateFactory the new replay state factory
	 */
	public function setReplayStateFactory(replayStateFactory:MockControlStateFactory):Void {
		this.replayStateFactory = replayStateFactory;
	}
	
	/**
	 * @see MockControl#getMock()
	 */
	public function getMock(Void) {
		if (!mock) mock = getMockProxyFactory().createProxy(type, createDelegator());
		return mock;
	}
	
	/**
	 * Creates a new InvocationHandler instance that handles method
	 * invocations on the proxy.
	 *
	 * @return a delegator that handles proxy method invocations
	 */
	private function createDelegator(Void):InvocationHandler {
		var result:InvocationHandler = new InvocationHandler();
		var owner:SimpleMockControl = this;
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
	 * @see MockControl#replay()
	 */
	public function replay(Void):Void {
		state = getReplayStateFactory().getMockControlState(behaviour);
	}
	
	/**
	 * @see MockControl#reset()
	 */
	public function reset(Void):Void {
		behaviour.removeAllBehaviour();
		state = getRecordStateFactory().getMockControlState(behaviour);
	}
	
	/**
	 * @see MockControl#setArgumentsMatcher()
	 */
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void {
		state.setArgumentsMatcher(argumentsMatcher);
	}
	
	/**
	 * @see MockControl#setDefaultReturnValue()
	 */
	public function setDefaultReturnValue(value):Void {
		var response:MethodResponse = new MethodResponse();
		response.setReturnValue(value);
		state.setResponse(response, new MethodCallRange());
	}
	
	/**
	 * @see MockControl#setDefaultThrowable()
	 */
	public function setDefaultThrowable(throwable):Void {
		var response:MethodResponse = new MethodResponse();
		response.setThrowable(throwable);
		state.setResponse(response, new MethodCallRange());
	}
	
	/**
	 * @see MockControl#setDefaultVoidCallable()
	 */
	public function setDefaultVoidCallable(Void):Void {
		state.setResponse(new MethodResponse(), new MethodCallRange());
	}
	
	/**
	 * @see MockControl#setReturnValue()
	 */
	public function setReturnValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Object], setReturnValueByValue);
		o.addHandler([Object, Number], setReturnValueByValueAndQuantity);
		o.addHandler([Object, Number, Number], setReturnValueByValueAndMinimumAndMaximumQuantity);
		o.forward(arguments);
	}
	
	/**
	 * @see MockControl#setReturnValueByValue()
	 */
	public function setReturnValueByValue(value):Void {
		setReturnValueByValueAndQuantity(value, 1);
	}
	
	/**
	 * @see MockControl#setReturnValueByValueAndQuantity()
	 */
	public function setReturnValueByValueAndQuantity(value, quantity:Number):Void {
		var response:MethodResponse = new MethodResponse();
		response.setReturnValue(value);
		state.setResponse(response, new MethodCallRange(quantity));
	}
	
	/**
	 * @see MockControl#setReturnValueByValueAndMinimumAndMaximumQuantity()
	 */
	public function setReturnValueByValueAndMinimumAndMaximumQuantity(value, minimumQuantity:Number, maximumQuantity:Number):Void {
		var response:MethodResponse = new MethodResponse();
		response.setReturnValue(value);
		state.setResponse(response, new MethodCallRange(minimumQuantity, maximumQuantity));
	}
	
	/**
	 * @see MockControl#setThrowable()
	 */
	public function setThrowable():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Object], setThrowableByThrowable);
		o.addHandler([Object, Number], setThrowableByThrowableAndQuantity);
		o.addHandler([Object, Number, Number], setThrowableByThrowableAndMinimumAndMaximumQuantity);
		o.forward(arguments);
	}
	
	/**
	 * @see MockControl#setThrowableByThrowable()
	 */
	public function setThrowableByThrowable(throwable):Void {
		setThrowableByThrowableAndQuantity(throwable, 1);
	}
	
	/**
	 * @see MockControl#setThrowableByThrowableAndQuantity()
	 */
	public function setThrowableByThrowableAndQuantity(throwable, quantity:Number):Void {
		var response:MethodResponse = new MethodResponse();
		response.setThrowable(throwable);
		state.setResponse(response, new MethodCallRange(quantity));
	}
	
	/**
	 * @see MockControl#setThrowableByThrowableAndMinimumAndMaximumQuantity()
	 */
	public function setThrowableByThrowableAndMinimumAndMaximumQuantity(throwable, minimumQuantity:Number, maximumQuantity:Number):Void {
		var response:MethodResponse = new MethodResponse();
		response.setThrowable(throwable);
		state.setResponse(response, new MethodCallRange(minimumQuantity, maximumQuantity));
	}
	
	/**
	 * @see MockControl#setVoidCallable()
	 */
	public function setVoidCallable():Void {
		var o:Overload = new Overload(this);
		o.addHandler([], setVoidCallableByVoid);
		o.addHandler([Number], setVoidCallableByQuantity);
		o.addHandler([Number, Number], setVoidCallableByMinimumAndMaximumQuantity);
		o.forward(arguments);
	}
	
	/**
	 * @see MockControl#setVoidCallableByVoid()
	 */
	public function setVoidCallableByVoid(Void):Void {
		setVoidCallableByQuantity(1);
	}
	
	/**
	 * @see MockControl#setVoidCallableByQuantity()
	 */
	public function setVoidCallableByQuantity(quantity:Number):Void {
		state.setResponse(new MethodResponse(), new MethodCallRange(quantity));
	}
	
	/**
	 * @see MockControl#setVoidCallableByMinimumAndMaximumQuantity()
	 */
	public function setVoidCallableByMinimumAndMaximumQuantity(minimumQuantity:Number, maximumQuantity:Number):Void {
		state.setResponse(new MethodResponse(), new MethodCallRange(minimumQuantity, maximumQuantity));
	}
	
	/**
	 * @see MockControl#verify()
	 */
	public function verify(testCase:TestCase):Void {
		state.verify(testCase);
	}
	
}