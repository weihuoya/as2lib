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
import org.as2lib.test.mock.MethodBehaviour;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.MethodBehaviourMock extends BasicClass implements MethodBehaviour {
	
	public static var RECORD:Number = 0;
	public static var REPLAY:Number = 1;
	
	private var testCase:TestCase;
	private var state:Number;
	private var __getExpectedMethodCall:Object;
	private var __addActualMethodCall:Object;
	private var __addMethodResponse:Object;
	private var __setArgumentsMatcher:Object;
	private var __expectsAnotherMehodCall:Object;
	private var __response:Object;
	private var __verify:Object;
	
	public function MethodBehaviourMock(testCase:TestCase) {
		this.testCase = testCase;
		state = RECORD;
		__getExpectedMethodCall = new Object();
		__addActualMethodCall = new Object();
		__addMethodResponse = new Object();
		__setArgumentsMatcher = new Object();
		__expectsAnotherMehodCall = new Object();
		__response = new Object();
		__verify = new Object();
	}
	
	public function replay(Void):Void {
		state = REPLAY;
	}
	
	public function setGetExpectedMethodCallReturnValue(returnValue:MethodCall):Void {
		__getExpectedMethodCall.returnValue = returnValue;
	}
	
	public function getExpectedMethodCall(Void):MethodCall {
		if (state == RECORD) {
			__getExpectedMethodCall.callExpected = true;
		} else {
			if (__getExpectedMethodCall.callExpected) {
				return __getExpectedMethodCall.returnValue;
			} else {
				testCase["fail"]("getExpectedMethodCall(..): Unexpected call.");
			}
		}
	}
	
	public function addActualMethodCall(actualMethodCall:MethodCall):Void {
		if (state == RECORD) {
			__addActualMethodCall.callExpected = true;
			__addActualMethodCall.actualMethodCall = actualMethodCall;
		} else {
			if (__addActualMethodCall.callExpected) {
				testCase["assertSame"]("Wrong actual method call.", __addActualMethodCall.actualMethodCall, actualMethodCall);
			} else {
				testCase["fail"]("addActualMethodCall(..): Unexpected call.");
			}
		}
	}
	
	public function addMethodResponse(methodResponse:MethodResponse, methodCallRange:MethodCallRange):Void {
		if (state == RECORD) {
			__addMethodResponse.callExpected = true;
			__addMethodResponse.methodResponse = methodResponse;
			__addMethodResponse.methodCallRange = methodCallRange;
		} else {
			if (__addMethodResponse.callExpected) {
				testCase["assertSame"]("Wrong method response.", __addMethodResponse.methodResponse, methodResponse);
				testCase["assertSame"]("Wrong method call range.", __addMethodResponse.methodCallRange, methodCallRange);
			} else {
				testCase["fail"]("addMethodResponse(..): Unexpected call.");
			}
		}
	}
	
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void {
		if (state == RECORD) {
			__setArgumentsMatcher.callExpected = true;
			__setArgumentsMatcher.argumentsMatcher = argumentsMatcher;
		} else {
			if (__setArgumentsMatcher.callExpected) {
				testCase["assertSame"]("Wrong arguments matcher.", __setArgumentsMatcher.argumentsMatcher, argumentsMatcher);
			} else {
				testCase["fail"]("setArgumentsMatcher(..): Unexpected call.");
			}
		}
	}
	
	public function setExpectsAnotherMehodCallReturnValue(returnValue:Boolean):Void {
		__expectsAnotherMehodCall.returnValue = returnValue;
	}
	
	public function expectsAnotherMehodCall(Void):Boolean {
		if (state == RECORD) {
			__expectsAnotherMehodCall.callExpected = true;
		} else {
			if (__expectsAnotherMehodCall.callExpected) {
				return __expectsAnotherMehodCall.returnValue;
			} else {
				testCase["fail"]("expectsAnotherMehodCall(..): Unexpected call.");
			}
		}
	}
	
	public function setResponseReturnValue(returnValue):Void {
		__response.returnValue = returnValue;
	}
	
	public function response(Void) {
		if (state == RECORD) {
			__response.callExpected = true;
		} else {
			if (__response.callExpected) {
				return __response.returnValue;
			} else {
				testCase["fail"]("response(..): Unexpected call.");
			}
		}
	}
	
	public function verify(testCase:TestCase):Void {
		if (state == RECORD) {
			__verify.callExpected = true;
			__verify.testCase = testCase;
		} else {
			if (__verify.callExpected) {
				testCase["assertSame"]("Wrong test case.", __verify.testCase, testCase);
			} else {
				testCase["fail"]("verify(..): Unexpected call.");
			}
		}
	}
	
}