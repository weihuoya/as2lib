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
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.test.mock.MethodBehavior;
import org.as2lib.test.mock.Behavior;
import org.as2lib.test.mock.MethodBehaviorFactory;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.support.DefaultMethodBehavior;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.DefaultBehavior extends BasicClass implements Behavior {
	
	/** Stores added method call behaviors. */
	private var methodBehaviors:Map;
	
	/** Currently used factory to create method call behaviors. */
	private var methodBehaviorFactory:MethodBehaviorFactory;
	
	private var lastMethodName:String;
	
	/**
	 * Constructs a new instance.
	 */
	public function DefaultBehavior(Void) {
		methodBehaviors = new PrimitiveTypeMap();
	}
	
	/**
	 * Returns either the factory set via #setMethodBehaviorFactory()
	 * or the default one which returns an instance of DefaultMethodBehavior.
	 *
	 * @return the currently used factory to obtain method call behaviors
	 */
	public function getMethodBehaviorFactory(Void):MethodBehaviorFactory {
		if (!methodBehaviorFactory) methodBehaviorFactory = getDefaultMethodBehaviorFactory();
		return methodBehaviorFactory;
	}
	
	/**
	 * @return the default method call behavior factory
	 */
	private function getDefaultMethodBehaviorFactory(Void):MethodBehaviorFactory {
		var result:MethodBehaviorFactory = new MethodBehaviorFactory();
		result.getMethodBehavior = function(expectedMethodCall:MethodCall):MethodBehavior {
			return new DefaultMethodBehavior(expectedMethodCall);
		}
		return result;
	}
	
	/**
	 * Sets the factory used to obtain method call behaviors to store state.
	 *
	 * <p>If you set a factory of null or undefined #getMethodBehaviorFactory(Void):MethodBehaviorFactory
	 * returns the default one.
	 *
	 * @param methodBehaviorFactory the new factory
	 */
	public function setMethodBehaviorFactory(methodBehaviorFactory:MethodBehaviorFactory):Void {
		this.methodBehaviorFactory = methodBehaviorFactory;
	}
	
	/**
	 * If the method name is null, undefined or a blank string the one
	 * returned by the method behaviour's expected method call will be used.
	 * If this is also null, undefined or a blank string a '[unknown]' will
	 * be used.
	 *
	 * @throws IllegalArgumentException if the passed-in method behavior is null or undefined
	 * @see Behavior#addMethodBehavior()
	 */
	public function addMethodBehavior(methodName:String, methodBehavior:MethodBehavior):Void {
		if (!methodBehavior) throw new IllegalArgumentException("Method behavior must not be null or undefined.", this, arguments);
		if (methodName == null || methodName == "") methodName = methodBehavior.getExpectedMethodCall().getMethodName();
		if (methodName == null || methodName == "") methodName = "[unknown]";
		lastMethodName = methodName;
		if (!methodBehaviors.containsKey(methodName)) methodBehaviors.put(methodName, new Array());
		var behaviors:Array = methodBehaviors.get(methodName);
		behaviors.push(methodBehavior);
	}
	
	/**
	 * @see Behavior#createMethodBehavior()
	 */
	public function createMethodBehavior(expectedMethodCall:MethodCall):MethodBehavior {
		return getMethodBehaviorFactory().getMethodBehavior(expectedMethodCall);
	}
	
	/**
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The actual method call is null or undefined.</li>
	 *   <li>There is no matching behavior registered.</li>
	 * </ul>
	 *
	 * @see Behavior#getMethodBehavior()
	 */
	public function getMethodBehavior(actualMethodCall:MethodCall):MethodBehavior {
		if (!actualMethodCall) return null;
		var methodName:String = actualMethodCall.getMethodName();
		if (methodName == null || methodName == "") methodName = "[unknown]";
		var behaviors:Array = methodBehaviors.get(methodName);
		var matchingBehaviors:Array = new Array();
		for (var i:Number = 0; i < behaviors.length; i++) {
			var behavior:MethodBehavior = behaviors[i];
			if (behavior.getExpectedMethodCall().matches(actualMethodCall)) {
				matchingBehaviors.push(behavior);
			}
		}
		if (matchingBehaviors.length < 1) return null;
		if (matchingBehaviors.length < 2) return matchingBehaviors[0];
		var result:MethodBehavior = matchingBehaviors[matchingBehaviors.length-1];
		for (var i:Number = behaviors.length-1; i > -1; i--) {
			var behavior:MethodBehavior = behaviors[i];
			if (behavior.expectsAnotherMethodCall()) {
				result = behavior;
			}
		}
		return result;
	}
	
	/**
	 * @see Behavior#getLastMethodBehavior()
	 */
	public function getLastMethodBehavior(Void):MethodBehavior {
		var behaviors:Array = methodBehaviors.get(lastMethodName);
		return behaviors[behaviors.length-1];
	}
	
	/**
	 * @see Behavior#removeAllBehavior()
	 */
	public function removeAllBehavior(Void):Void {
		methodBehaviors.clear();
	}
	
	/**
	 * @see Behavior#verify()
	 */
	public function verify(Void):Void {
		var behaviors:Array = methodBehaviors.getValues();
		for (var i:Number = 0; i < behaviors.length; i++) {
			for (var k:Number = 0; k < behaviors[i].length; k++) {
				MethodBehavior(behaviors[i][k]).verify();
			}
		}
	}
	
}