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
import org.as2lib.test.mock.Behaviour;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MethodBehaviour;
import org.as2lib.test.mock.MethodCall;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.BehaviourMock extends BasicClass implements Behaviour {
	
	public static var RECORD:Number = 0;
	public static var REPLAY:Number = 1;
	
	private var testCase:TestCase;
	private var state:Number;
	private var __addMethodBehaviour:Object;
	private var __createMethodBehaviour:Object;
	private var __getMethodBehaviour:Object;
	private var __getLastMethodBehaviour:Object;
	private var __removeAllBehaviour:Object;
	private var __verify:Object;
	
	public function BehaviourMock(testCase:TestCase) {
		this.testCase = testCase;
		state = RECORD;
		__addMethodBehaviour = new Object();
		__createMethodBehaviour = new Object();
		__getMethodBehaviour = new Object();
		__getLastMethodBehaviour = new Object();
		__removeAllBehaviour = new Object();
		__verify = new Object();
	}
	
	public function replay(Void):Void {
		state = REPLAY;
	}
	
	public function doVerify(Void):Void {
		if (__addMethodBehaviour.callExpected != __addMethodBehaviour.called) testCase["fail"]("addMethodBehaviour(..): Expected call.");
		if (__createMethodBehaviour.callExpected != __createMethodBehaviour.called) testCase["fail"]("createMethodBehaviour(..): Expected call.");
		if (__getMethodBehaviour.callExpected != __getMethodBehaviour.called) testCase["fail"]("getMethodBehaviour(..): Expected call.");
		if (__getLastMethodBehaviour.callExpected != __getLastMethodBehaviour.called) testCase["fail"]("getLastMethodBehaviour(..): Expected call.");
		if (__removeAllBehaviour.callExpected != __removeAllBehaviour.called) testCase["fail"]("removeAllBehaviour(..): Expected call.");
		if (__verify.callExpected != __verify.called) testCase["fail"]("verify(..): Expected call.");
	}
	
	public function addMethodBehaviour(methodName:String, methodBehaviour:MethodBehaviour):Void {
		if (state == RECORD) {
			__addMethodBehaviour.callExpected = true;
			__addMethodBehaviour.methodName = methodName;
			__addMethodBehaviour.methodBehaviour = methodBehaviour;
		} else {
			if (__addMethodBehaviour.callExpected) {
				__addMethodBehaviour.called = true;
				testCase["assertSame"]("Wrong method name.", __addMethodBehaviour.methodName, methodName);
				testCase["assertSame"]("Wrong method behaviour.", __addMethodBehaviour.methodBehaviour, methodBehaviour);
			} else {
				testCase["fail"]("addMethodBehaviour(..): Unexpected call.");
			}
		}
	}
	
	public function setCreateMethodBehaviourReturnValue(returnValue:MethodBehaviour):Void {
		__createMethodBehaviour.returnValue = returnValue;
	}
	
	public function createMethodBehaviour(expectedMethodCall:MethodCall):MethodBehaviour {
		if (state == RECORD) {
			__createMethodBehaviour.callExpected = true;
			__createMethodBehaviour.expectedMethodCall = expectedMethodCall;
		} else {
			if (__createMethodBehaviour.callExpected) {
				__createMethodBehaviour.called = true;
				testCase["assertSame"]("Wrong expected method call.", __createMethodBehaviour.expectedMethodCall, expectedMethodCall);
				return __createMethodBehaviour.returnValue;
			} else {
				testCase["fail"]("createMethodBehaviour(..): Unexpected call.");
			}
		}
	}
	
	public function setGetMethodBehaviourReturnValue(returnValue:MethodBehaviour):Void {
		__getMethodBehaviour.returnValue = returnValue;
	}
	
	public function getMethodBehaviour(actualMethodCall:MethodCall):MethodBehaviour {
		if (state == RECORD) {
			__getMethodBehaviour.callExpected = true;
			__getMethodBehaviour.actualMethodCall = actualMethodCall;
		} else {
			if (__getMethodBehaviour.callExpected) {
				__getMethodBehaviour.called = true;
				testCase["assertSame"]("Wrong actual method call.", __getMethodBehaviour.actualMethodCall, actualMethodCall);
				return __getMethodBehaviour.returnValue;
			} else {
				testCase["fail"]("getMethodBehaviour(..): Unexpected call.");
			}
		}
	}
	
	public function setGetLastMethodBehaviourReturnValue(returnValue:MethodBehaviour):Void {
		__getLastMethodBehaviour.returnValue = returnValue;
	}
	
	public function getLastMethodBehaviour(Void):MethodBehaviour {
		if (state == RECORD) {
			__getLastMethodBehaviour.callExpected = true;
		} else {
			if (__getLastMethodBehaviour.callExpected) {
				__getLastMethodBehaviour.called = true;
				return __getLastMethodBehaviour.returnValue;
			} else {
				testCase["fail"]("getLastMethodBehaviour(..): Unexpected call.");
			}
		}
	}
	
	public function removeAllBehaviour(Void):Void {
		if (state == RECORD) {
			__removeAllBehaviour.callExpected = true;
		} else {
			if (__removeAllBehaviour.callExpected) {
				__removeAllBehaviour.called = true;
			} else {
				testCase["fail"]("removeAllBehaviour(..): Unexpected call.");
			}
		}
	}
	
	public function verify(testCase:TestCase):Void {
		if (state == RECORD) {
			__verify.callExpected = true;
			__verify.testCase = testCase;
		} else {
			if (__verify.callExpected) {
				__verify.called = true;
				testCase["assertSame"]("Wrong test case.", __verify.testCase, testCase);
			} else {
				testCase["fail"]("verify(..): Unexpected call.");
			}
		}
	}
	
}