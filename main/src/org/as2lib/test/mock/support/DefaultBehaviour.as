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
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MethodBehaviour;
import org.as2lib.test.mock.Behaviour;
import org.as2lib.test.mock.MethodBehaviourFactory;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.support.DefaultMethodBehaviour;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.DefaultBehaviour extends BasicClass implements Behaviour {
	
	/** Stores added method call behaviours. */
	private var methodBehaviours:Map;
	
	/** Currently used factory to create method call behaviours. */
	private var methodBehaviourFactory:MethodBehaviourFactory;
	
	private var lastMethodName:String;
	
	/**
	 * Constructs a new instance.
	 */
	public function DefaultBehaviour(Void) {
		methodBehaviours = new PrimitiveTypeMap();
	}
	
	/**
	 * Returns either the factory set via #setMethodBehaviourFactory()
	 * or the default one.
	 *
	 * @return the currently used factory to obtain method call behaviours
	 */
	public function getMethodBehaviourFactory(Void):MethodBehaviourFactory {
		if (!methodBehaviourFactory) methodBehaviourFactory = getDefaultMethodBehaviourFactory();
		return methodBehaviourFactory;
	}
	
	/**
	 * @return the default method call behaviour factory
	 */
	private function getDefaultMethodBehaviourFactory(Void):MethodBehaviourFactory {
		var result:MethodBehaviourFactory = new MethodBehaviourFactory();
		result.getMethodBehaviour = function(expectedMethodCall:MethodCall):MethodBehaviour {
			return new DefaultMethodBehaviour(expectedMethodCall);
		}
		return result;
	}
	
	/**
	 * Sets the factory used to obtain method call behaviours to store state.
	 *
	 * @param methodBehaviourFactory the new factory
	 */
	public function setMethodBehaviourFactory(methodBehaviourFactory:MethodBehaviourFactory):Void {
		this.methodBehaviourFactory = methodBehaviourFactory;
	}
	
	/**
	 * @see Behaviour#addMethodBehaviour()
	 */
	public function addMethodBehaviour(methodName:String, methodBehaviour:MethodBehaviour):Void {
		if (!methodBehaviour) throw new IllegalArgumentException("Method behaviour must not be null or undefined.", this, arguments);
		if (methodName == null || methodName == "") methodName = methodBehaviour.getExpectedMethodCall().getMethodName();
		if (methodName == null || methodName == "") methodName = "[unknown]";
		lastMethodName = methodName;
		if (!methodBehaviours.containsKey(methodName)) methodBehaviours.put(methodName, new Array());
		var behaviours:Array = methodBehaviours.get(methodName);
		behaviours.push(methodBehaviour);
	}
	
	/**
	 * @see Behaviour#createMethodBehaviour()
	 */
	public function createMethodBehaviour(expectedMethodCall:MethodCall):MethodBehaviour {
		return getMethodBehaviourFactory().getMethodBehaviour(expectedMethodCall);
	}
	
	/**
	 * @see Behaviour#getMethodBehaviour()
	 */
	public function getMethodBehaviour(actualMethodCall:MethodCall):MethodBehaviour {
		if (!actualMethodCall) return null;
		var methodName:String = actualMethodCall.getMethodName();
		if (methodName == null || methodName == "") methodName = "[unknown]";
		var behaviours:Array = methodBehaviours.get(methodName);
		var matchingBehaviours:Array = new Array();
		for (var i:Number = 0; i < behaviours.length; i++) {
			var behaviour:MethodBehaviour = behaviours[i];
			if (behaviour.getExpectedMethodCall().matches(actualMethodCall)) {
				matchingBehaviours.push(behaviour);
			}
		}
		if (matchingBehaviours.length < 1) return null;
		if (matchingBehaviours.length < 2) return matchingBehaviours[0];
		var result:MethodBehaviour = matchingBehaviours[matchingBehaviours.length-1];
		for (var i:Number = behaviours.length-1; i > -1; i--) {
			var behaviour:MethodBehaviour = behaviours[i];
			if (behaviour.expectsAnotherMethodCall()) {
				result = behaviour;
			}
		}
		return result;
	}
	
	/**
	 * @see Behaviour#getLastMethodBehaviour()
	 */
	public function getLastMethodBehaviour(Void):MethodBehaviour {
		var behaviours:Array = methodBehaviours.get(lastMethodName);
		return behaviours[behaviours.length-1];
	}
	
	/**
	 * @see Behaviour#removeAllBehaviour()
	 */
	public function removeAllBehaviour(Void):Void {
		methodBehaviours.clear();
	}
	
	/**
	 * @see Behaviour#verify()
	 */
	public function verify(testCase:TestCase):Void {
		var behaviours:Array = methodBehaviours.getValues();
		for (var i:Number = 0; i < behaviours.length; i++) {
			for (var k:Number = 0; k < behaviours[i].length; k++) {
				MethodBehaviour(behaviours[i][k]).verify(testCase);
			}
		}
	}
	
}