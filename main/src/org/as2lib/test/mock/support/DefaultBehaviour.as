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
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MethodCallBehaviour;
import org.as2lib.test.mock.Behaviour;
import org.as2lib.test.mock.MethodCallBehaviourFactory;
import org.as2lib.test.mock.support.DefaultMethodCallBehaviour;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.DefaultBehaviour extends BasicClass implements Behaviour {
	
	/** Stores added method call behaviours. */
	private var methodCallBehaviours:Map;
	
	/** Currently used factory to create method call behaviours. */
	private var methodCallBehaviourFactory:MethodCallBehaviourFactory;
	
	/**
	 * Constructs a new instance.
	 */
	public function DefaultBehaviour(Void) {
		methodCallBehaviours = new PrimitiveTypeMap();
	}
	
	/**
	 * Returns either the factory set via #setMethodCallBehaviourFactory()
	 * or the default one.
	 *
	 * @return the currently used factory to obtain method call behaviours
	 */
	public function getMethodCallBehaviourFactory(Void):MethodCallBehaviourFactory {
		if (!methodCallBehaviourFactory) methodCallBehaviourFactory = getDefaultMethodCallBehaviourFactory();
		return methodCallBehaviourFactory;
	}
	
	/**
	 * @return the default method call behaviour factory
	 */
	private function getDefaultMethodCallBehaviourFactory(Void):MethodCallBehaviourFactory {
		var result:MethodCallBehaviourFactory = new MethodCallBehaviourFactory();
		result.getMethodCallBehaviour = function(methodName:String):MethodCallBehaviour {
			return new DefaultMethodCallBehaviour(methodName);
		}
		return result;
	}
	
	/**
	 * Sets the factory used to obtain method call behaviours to store state.
	 *
	 * @param methodCallBehaviourFactory the new factory
	 */
	public function setMethodCallBehaviourFactory(methodCallBehaviourFactory:MethodCallBehaviourFactory):Void {
		this.methodCallBehaviourFactory = methodCallBehaviourFactory;
	}
	
	/**
	 * @see Behaviour#addMethodCallBehaviour()
	 */
	public function addMethodCallBehaviour(methodName:String):MethodCallBehaviour {
		if (!methodCallBehaviours.containsKey(methodName)) methodCallBehaviours.put(methodName, new Array());
		var behaviours:Array = methodCallBehaviours.get(methodName);
		behaviours.push(getMethodCallBehaviourFactory().getMethodCallBehaviour(methodName));
		return behaviours[behaviours.length-1];
	}
	
	/**
	 * @see Behaviour#getMethodCallBehaviour()
	 */
	public function getMethodCallBehaviour(methodName:String, args:Array):MethodCallBehaviour {
		var behaviours:Array = methodCallBehaviours.get(methodName);
		var matchingBehaviours:Array = new Array();
		for (var i:Number = 0; i < behaviours.length; i++) {
			var behaviour:MethodCallBehaviour = behaviours[i];
			if (behaviour.getArgumentsMatcher().matchArguments(behaviour.getExpectedCall().getArguments(), args)) {
				matchingBehaviours.push(behaviour);
			}
		}
		if (matchingBehaviours.length < 1) return null;
		if (matchingBehaviours.length < 2) return matchingBehaviours[0];
		var result:MethodCallBehaviour = matchingBehaviours[matchingBehaviours.length-1];
		for (var i:Number = behaviours.length-1; i > -1; i--) {
			var behaviour:MethodCallBehaviour = behaviours[i];
			if (behaviour.getExpectedRange().contains(behaviour.getActualCallCount())) {
				result = behaviour;
			}
		}
		return result;
	}
	
	/**
	 * @see Behaviour#getLastMethodCallBehaviour()
	 */
	public function getLastMethodCallBehaviour(Void):MethodCallBehaviour {
		var behaviours:Array = methodCallBehaviours.getValues()[methodCallBehaviours.size()-1];
		return behaviours[behaviours.length-1];
	}
	
	/**
	 * @see Behaviour#removeAllBehaviour()
	 */
	public function removeAllBehaviour(Void):Void {
		methodCallBehaviours.clear();
	}
	
	/**
	 * @see Behaviour#verify()
	 */
	public function verify(testCase:TestCase):Void {
		var behaviours:Array = methodCallBehaviours.getValues();
		for (var i:Number = 0; i < behaviours.length; i++) {
			for (var k:Number = 0; k < behaviours[i].length; k++) {
				MethodCallBehaviour(behaviours[i][k]).verify(testCase);
			}
		}
	}
	
}