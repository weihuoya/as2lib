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
import org.as2lib.test.mock.Behavior;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MethodBehavior;
import org.as2lib.test.mock.MethodCall;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.BehaviorMock extends BasicClass implements Behavior {
	
	public static var RECORD:Number = 0;
	public static var REPLAY:Number = 1;
	
	private var testCase:TestCase;
	private var state:Number;
	private var __addMethodBehavior:Object;
	private var __createMethodBehavior:Object;
	private var __getMethodBehavior:Object;
	private var __getLastMethodBehavior:Object;
	private var __removeAllBehaviors:Object;
	private var __verify:Object;
	
	public function BehaviorMock(testCase:TestCase) {
		this.testCase = testCase;
		state = RECORD;
		__addMethodBehavior = new Object();
		__createMethodBehavior = new Object();
		__getMethodBehavior = new Object();
		__getLastMethodBehavior = new Object();
		__removeAllBehaviors = new Object();
		__verify = new Object();
	}
	
	public function replay(Void):Void {
		state = REPLAY;
	}
	
	public function doVerify(Void):Void {
		if (__addMethodBehavior.callExpected != __addMethodBehavior.called) testCase["fail"]("addMethodBehavior(..): Expected call.");
		if (__createMethodBehavior.callExpected != __createMethodBehavior.called) testCase["fail"]("createMethodBehavior(..): Expected call.");
		if (__getMethodBehavior.callExpected != __getMethodBehavior.called) testCase["fail"]("getMethodBehavior(..): Expected call.");
		if (__getLastMethodBehavior.callExpected != __getLastMethodBehavior.called) testCase["fail"]("getLastMethodBehavior(..): Expected call.");
		if (__removeAllBehaviors.callExpected != __removeAllBehaviors.called) testCase["fail"]("removeAllBehaviors(..): Expected call.");
		if (__verify.callExpected != __verify.called) testCase["fail"]("verify(..): Expected call.");
	}
	
	public function addMethodBehavior(methodName:String, methodBehavior:MethodBehavior):Void {
		if (state == RECORD) {
			__addMethodBehavior.callExpected = true;
			__addMethodBehavior.methodName = methodName;
			__addMethodBehavior.methodBehavior = methodBehavior;
		} else {
			if (__addMethodBehavior.callExpected) {
				__addMethodBehavior.called = true;
				testCase["assertSame"]("Wrong method name.", __addMethodBehavior.methodName, methodName);
				testCase["assertSame"]("Wrong method behavior.", __addMethodBehavior.methodBehavior, methodBehavior);
			} else {
				testCase["fail"]("addMethodBehavior(..): Unexpected call.");
			}
		}
	}
	
	public function setCreateMethodBehaviorReturnValue(returnValue:MethodBehavior):Void {
		__createMethodBehavior.returnValue = returnValue;
	}
	
	public function createMethodBehavior(expectedMethodCall:MethodCall):MethodBehavior {
		if (state == RECORD) {
			__createMethodBehavior.callExpected = true;
			__createMethodBehavior.expectedMethodCall = expectedMethodCall;
		} else {
			if (__createMethodBehavior.callExpected) {
				__createMethodBehavior.called = true;
				testCase["assertSame"]("Wrong expected method call.", __createMethodBehavior.expectedMethodCall, expectedMethodCall);
				return __createMethodBehavior.returnValue;
			} else {
				testCase["fail"]("createMethodBehavior(..): Unexpected call.");
			}
		}
	}
	
	public function setGetMethodBehaviorReturnValue(returnValue:MethodBehavior):Void {
		__getMethodBehavior.returnValue = returnValue;
	}
	
	public function getMethodBehavior(actualMethodCall:MethodCall):MethodBehavior {
		if (state == RECORD) {
			__getMethodBehavior.callExpected = true;
			__getMethodBehavior.actualMethodCall = actualMethodCall;
		} else {
			if (__getMethodBehavior.callExpected) {
				__getMethodBehavior.called = true;
				testCase["assertSame"]("Wrong actual method call.", __getMethodBehavior.actualMethodCall, actualMethodCall);
				return __getMethodBehavior.returnValue;
			} else {
				testCase["fail"]("getMethodBehavior(..): Unexpected call.");
			}
		}
	}
	
	public function setGetLastMethodBehaviorReturnValue(returnValue:MethodBehavior):Void {
		__getLastMethodBehavior.returnValue = returnValue;
	}
	
	public function getLastMethodBehavior(Void):MethodBehavior {
		if (state == RECORD) {
			__getLastMethodBehavior.callExpected = true;
		} else {
			if (__getLastMethodBehavior.callExpected) {
				__getLastMethodBehavior.called = true;
				return __getLastMethodBehavior.returnValue;
			} else {
				testCase["fail"]("getLastMethodBehavior(..): Unexpected call.");
			}
		}
	}
	
	public function removeAllBehaviors(Void):Void {
		if (state == RECORD) {
			__removeAllBehaviors.callExpected = true;
		} else {
			if (__removeAllBehaviors.callExpected) {
				__removeAllBehaviors.called = true;
			} else {
				testCase["fail"]("removeAllBehaviors(..): Unexpected call.");
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