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
import org.as2lib.test.mock.MethodCallBehaviour;
import org.as2lib.test.mock.MockBehaviour;
import org.as2lib.test.mock.MethodCallBehaviourFactory;
import org.as2lib.test.mock.support.DefaultMethodCallBehaviour;
import org.as2lib.test.mock.AssertionFailedError;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.DefaultMockBehaviour extends BasicClass implements MockBehaviour {
	
	/** Stores added method call behaviours. */
	private var methodCallBehaviours:Map;
	
	/** Currently used factory to create method call behaviours. */
	private var methodCallBehaviourFactory:MethodCallBehaviourFactory;
	
	/**
	 * Constructs a new instance.
	 */
	public function DefaultMockBehaviour(Void) {
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
	 * @see MockBehaviour#addMethodCallBehaviour()
	 */
	public function addMethodCallBehaviour(methodName:String):MethodCallBehaviour {
		methodCallBehaviours.put(methodName, getMethodCallBehaviourFactory().getMethodCallBehaviour(methodName));
		return methodCallBehaviours.get(methodName);
	}
	
	/**
	 * @see MockBehaviour#getMethodCallBehaviour()
	 */
	public function getMethodCallBehaviour(methodName:String):MethodCallBehaviour {
		return methodCallBehaviours.get(methodName);
	}
	
	/**
	 * @see MockBehaviour#getLastMethodCallBehaviour()
	 */
	public function getLastMethodCallBehaviour(Void):MethodCallBehaviour {
		return methodCallBehaviours.getValues()[methodCallBehaviours.size()-1];
	}
	
	/**
	 * @see MockBehaviour#removeAllBehaviour()
	 */
	public function removeAllBehaviour(Void):Void {
		methodCallBehaviours.clear();
	}
	
	/**
	 * @see MockBehaviour#verify()
	 */
	public function verify(Void):Void {
		var behaviours:Array = methodCallBehaviours.getValues();
		var errorMessage:String = "";
		for (var i:Number = 0; i < behaviours.length; i++) {
			try {
				MethodCallBehaviour(behaviours[i]).verify();
			} catch (exception:org.as2lib.test.mock.AssertionFailedError) {
				errorMessage += exception.getMessage() + "\n";
			}
		}
		if (errorMessage) throw new AssertionFailedError(errorMessage, this, arguments);
	}
	
}