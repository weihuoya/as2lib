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
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MockControlState;
import org.as2lib.test.mock.MethodBehaviour;
import org.as2lib.test.mock.Behaviour;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.RecordState extends BasicClass implements MockControlState {
	
	/** Used to add and get method behaviours. */
	private var behaviour:Behaviour;
	
	/**
	 * Constructs a new instance.
	 *
	 * @param behaviour used to add and get method call behaviours
	 */
	public function RecordState(behaviour:Behaviour) {
		if (!behaviour) throw new IllegalArgumentException("Behaviour is not allowed to be null or undefined.", this, arguments);
		this.behaviour = behaviour;
	}
	
	public function getBehaviour(Void):Behaviour {
		return behaviour;
	}
	
	/**
	 * @see MockControlState#invokeMethod()
	 */
	public function invokeMethod(methodCall:MethodCall) {
		var methodBehaviour:MethodBehaviour = behaviour.createMethodBehaviour(methodCall);
		if (methodCall.getMethodName() && methodCall.getMethodName() != "") {
			behaviour.addMethodBehaviour(methodCall.getMethodName(), methodBehaviour);
		} else {
			behaviour.addMethodBehaviour("[unknown]", methodBehaviour);
		}
	}
	
	/**
	 * @see MockControlState#setMethodResponse()
	 */ 
	public function setMethodResponse(methodResponse:MethodResponse, methodCallRange:MethodCallRange):Void {
		behaviour.getLastMethodBehaviour().addMethodResponse(methodResponse, methodCallRange);
	}
	
	/**
	 * @see MockControlState#setArgumentsMatcher()
	 */
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void {
		behaviour.getLastMethodBehaviour().setArgumentsMatcher(argumentsMatcher);
	}
	
	/**
	 * @see MockControlState#verify()
	 */
	public function verify(testCase:TestCase):Void {
		throw new IllegalStateException("Method must not be called in record state.", this, arguments);
	}
	
}