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
import org.as2lib.test.mock.MethodBehaviorFactory;
import org.as2lib.test.mock.MethodBehavior;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MethodCall;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.MethodBehaviorFactoryMock extends BasicClass implements MethodBehaviorFactory {
	
	public static var RECORD:Number = 0;
	public static var REPLAY:Number = 1;
	
	private var testCase:TestCase;
	private var state:Number;
	private var __getMethodBehavior:Object;
	
	public function MethodBehaviorFactoryMock(testCase:TestCase) {
		this.testCase = testCase;
		state = RECORD;
		__getMethodBehavior = new Object();
	}
	
	public function replay(Void):Void {
		state = REPLAY;
	}
	
	public function doVerify(Void):Void {
		if (__getMethodBehavior.callExpected != __getMethodBehavior.called) testCase["fail"]("getMethodBehavior(..): Expected call.");
	}
	
	public function setGetMethodBehaviorReturnValue(returnValue:MethodBehavior):Void {
		__getMethodBehavior.returnValue = returnValue;
	}
	
	public function getMethodBehavior(expectedMethodCall:MethodCall):MethodBehavior {
		if (state == RECORD) {
			__getMethodBehavior.callExpected = true;
			__getMethodBehavior.expectedMethodCall = expectedMethodCall;
		} else {
			if (__getMethodBehavior.callExpected) {
				__getMethodBehavior.called = true;
				testCase["assertSame"]("Wrong expected method call.", __getMethodBehavior.expectedMethodCall, expectedMethodCall);
				return __getMethodBehavior.returnValue;
			} else {
				testCase["fail"]("getMethodBehavior(..): Unexpected call.");
			}
		}
	}
	
}