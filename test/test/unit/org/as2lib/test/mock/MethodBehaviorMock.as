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
import org.as2lib.test.mock.MethodBehavior;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.MethodBehaviorMock extends BasicClass implements MethodBehavior {
	
	public static var RECORD:Number = 0;
	public static var REPLAY:Number = 1;
	
	private var testCase:TestCase;
	private var state:Number;
	private var __getExpectedMethodCall:Object;
	private var __addActualMethodCall:Object;
	private var __addMethodResponse:Object;
	private var __setArgumentsMatcher:Object;
	private var __expectsAnotherMethodCall:Object;
	private var __response:Object;
	private var __verify:Object;
	
	public function MethodBehaviorMock(testCase:TestCase) {
		this.testCase = testCase;
		state = RECORD;
		__getExpectedMethodCall = new Object();
		__addActualMethodCall = new Object();
		__addMethodResponse = new Object();
		__setArgumentsMatcher = new Object();
		__expectsAnotherMethodCall = new Object();
		__response = new Object();
		__verify = new Object();
	}
	
	public function replay(Void):Void {
		state = REPLAY;
	}
	
	public function doVerify(Void):Void {
		if (__getExpectedMethodCall.callExpected != __getExpectedMethodCall.called) testCase["fail"]("getExpectedMethodCall(..): Expected method call.");
		if (__addActualMethodCall.callExpected != __addActualMethodCall.called) testCase["fail"]("addActualMethodCall(..): Expected method call.");
		if (__addMethodResponse.callExpected != __addMethodResponse.called) testCase["fail"]("addMethodResponse(..): Expected method call.");
		if (__setArgumentsMatcher.callExpected != __setArgumentsMatcher.called) testCase["fail"]("setArgumentsMatcher(..): Expected method call.");
		if (__expectsAnotherMethodCall.callExpected != __expectsAnotherMethodCall.called) testCase["fail"]("expectsAnotherMethodCall(..): Expected method call.");
		if (__response.callExpected != __response.called) testCase["fail"]("response(..): Expected method call.");
		if (__verify.callExpected != __verify.called) testCase["fail"]("verify(..): Expected method call.");
	}
	
	public function setGetExpectedMethodCallReturnValue(returnValue:MethodCall):Void {
		__getExpectedMethodCall.returnValue = returnValue;
	}
	
	public function getExpectedMethodCall(Void):MethodCall {
		if (state == RECORD) {
			__getExpectedMethodCall.callExpected = true;
		} else {
			if (__getExpectedMethodCall.callExpected) {
				__getExpectedMethodCall.called = true;
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
				__addActualMethodCall.called = true;
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
				__addMethodResponse.called = true;
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
				__setArgumentsMatcher.called = true;
				testCase["assertSame"]("Wrong arguments matcher.", __setArgumentsMatcher.argumentsMatcher, argumentsMatcher);
			} else {
				testCase["fail"]("setArgumentsMatcher(..): Unexpected call.");
			}
		}
	}
	
	public function setExpectsAnotherMethodCallReturnValue(returnValue:Boolean):Void {
		__expectsAnotherMethodCall.returnValue = returnValue;
	}
	
	public function expectsAnotherMethodCall(Void):Boolean {
		if (state == RECORD) {
			__expectsAnotherMethodCall.callExpected = true;
		} else {
			if (__expectsAnotherMethodCall.callExpected) {
				__expectsAnotherMethodCall.called = true;
				return __expectsAnotherMethodCall.returnValue;
			} else {
				testCase["fail"]("expectsAnotherMethodCall(..): Unexpected call.");
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
				__response.called = true;
				return __response.returnValue;
			} else {
				testCase["fail"]("response(..): Unexpected call.");
			}
		}
	}
	
	public function verify(Void):Void {
		if (state == RECORD) {
			__verify.callExpected = true;
		} else {
			if (__verify.callExpected) {
				__verify.called = true;
			} else {
				testCase["fail"]("verify(..): Unexpected call.");
			}
		}
	}
	
}