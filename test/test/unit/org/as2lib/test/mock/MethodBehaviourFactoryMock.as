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
import org.as2lib.test.mock.MethodBehaviourFactory;
import org.as2lib.test.mock.MethodBehaviour;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MethodCall;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.MethodBehaviourFactoryMock extends BasicClass implements MethodBehaviourFactory {
	
	public static var RECORD:Number = 0;
	public static var REPLAY:Number = 1;
	
	private var testCase:TestCase;
	private var state:Number;
	private var __getMethodBehaviour:Object;
	
	public function MethodBehaviourFactoryMock(testCase:TestCase) {
		this.testCase = testCase;
		state = RECORD;
		__getMethodBehaviour = new Object();
	}
	
	public function replay(Void):Void {
		state = REPLAY;
	}
	
	public function doVerify(Void):Void {
		if (__getMethodBehaviour.callExpected != __getMethodBehaviour.called) testCase["fail"]("getMethodBehaviour(..): Expected call.");
	}
	
	public function setGetMethodBehaviourReturnValue(returnValue:MethodBehaviour):Void {
		__getMethodBehaviour.returnValue = returnValue;
	}
	
	public function getMethodBehaviour(expectedMethodCall:MethodCall):MethodBehaviour {
		if (state == RECORD) {
			__getMethodBehaviour.callExpected = true;
			__getMethodBehaviour.expectedMethodCall = expectedMethodCall;
		} else {
			if (__getMethodBehaviour.callExpected) {
				__getMethodBehaviour.called = true;
				testCase["assertSame"]("Wrong expected method call.", __getMethodBehaviour.expectedMethodCall, expectedMethodCall);
				return __getMethodBehaviour.returnValue;
			} else {
				testCase["fail"]("getMethodBehaviour(..): Unexpected call.");
			}
		}
	}
	
}