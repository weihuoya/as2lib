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
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MockControlState;
import org.as2lib.test.mock.MethodCallBehaviour;
import org.as2lib.test.mock.MockBehaviour;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.MethodCall;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.RecordState extends BasicClass implements MockControlState {
	
	/** Used to add and get method call behaviours. */
	private var behaviour:MockBehaviour;
	
	/**
	 * Constructs a new instance.
	 *
	 * @param behaviour used to add and get method call behaviours
	 */
	public function RecordState(behaviour:MockBehaviour) {
		this.behaviour = behaviour;
	}
	
	/**
	 * @see MockControlState#invokeMethod()
	 */
	public function invokeMethod(call:MethodCall) {
		var callBehaviour:MethodCallBehaviour = behaviour.addMethodCallBehaviour(call.getMethodName());
		callBehaviour.setExpectedCall(call);
	}
	
	/**
	 * @see MockControlState#setResponse()
	 */ 
	public function setResponse(response:MethodResponse, range:MethodCallRange):Void {
		var callBehaviour:MethodCallBehaviour = behaviour.getLastMethodCallBehaviour();
		callBehaviour.setResponse(response);
		callBehaviour.setExpectedRange(range);
	}
	
	/**
	 * @see MockControlState#verify()
	 */
	public function verify(testCase:TestCase):Void {
		throw new IllegalStateException("Method must not be called in record state.", this, arguments);
	}
	
}