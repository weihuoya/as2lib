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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.test.mock.MethodCallRangeError;
import org.as2lib.test.mock.MethodBehaviour;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.DefaultMethodBehaviour extends BasicClass implements MethodBehaviour {
	
	private var expectedMethodCall:MethodCall;
	private var actualMethodCalls:Array;
	private var methodCallRanges:Array;
	private var methodResponses:Array;
	
	public function DefaultMethodBehaviour(expectedMethodCall:MethodCall) {
		this.expectedMethodCall = expectedMethodCall;
		actualMethodCalls = new Array();
		methodCallRanges = new Array();
		methodResponses = new Array();
	}
	
	public function getExpectedMethodCall(Void):MethodCall {
		return expectedMethodCall;
	}
	
	public function addActualMethodCall(actualMethodCall:MethodCall):Void {
		if (!actualMethodCall) throw new IllegalArgumentException("Actual method call is not allowed to be null or undefined.", this, arguments);
		if (!expectedMethodCall.matches(actualMethodCall) && expectedMethodCall) {
			var error:MethodCallRangeError = new MethodCallRangeError("Unexpected method call", this, arguments);
			error.addMethodCall(actualMethodCall, new MethodCallRange(0), new MethodCallRange(1));
			error.addMethodCall(expectedMethodCall, new MethodCallRange(getTotalMinimumMethodCallCount(), getTotalMaximumMethodCallCount()), new MethodCallRange(actualMethodCalls.length));
			throw error;
		}
		actualMethodCalls.push(actualMethodCall);
		if (!expectedMethodCall) {
			var error:MethodCallRangeError = new MethodCallRangeError("Unexpected method call", this, arguments);
			error.addMethodCall(actualMethodCall, new MethodCallRange(0), new MethodCallRange(actualMethodCalls.length));
			throw error;
		}
		if (actualMethodCalls.length > getTotalMaximumMethodCallCount()) {
			var error:MethodCallRangeError = new MethodCallRangeError("Unexpected method call", this, arguments);
			error.addMethodCall(actualMethodCall, new MethodCallRange(getTotalMinimumMethodCallCount(), getTotalMaximumMethodCallCount()), new MethodCallRange(actualMethodCalls.length));
			throw error;
		}
	}
	
	private function getTotalMinimumMethodCallCount(Void):Number {
		if (!expectedMethodCall) return 0;
		if (methodCallRanges.length < 1) return 1;
		var result:Number = 0;
		for (var i:Number = 0; i < methodCallRanges.length; i++) {
			result += MethodCallRange(methodCallRanges[i]).getMinimum();
		}
		return result;
	}
	
	private function getTotalMaximumMethodCallCount(Void):Number {
		if (!expectedMethodCall) return 0;
		if (methodCallRanges.length < 1) return 1;
		var result:Number = 0;
		for (var i:Number = 0; i < methodCallRanges.length; i++) {
			result += MethodCallRange(methodCallRanges[i]).getMaximum();
		}
		return result;
	}

	public function addMethodResponse(methodResponse:MethodResponse, methodCallRange:MethodCallRange):Void {
		if (!expectedMethodCall) throw new IllegalStateException("It is not possible to set a response for an not-expected method call.", this, arguments);
		methodResponses.push(methodResponse);
		methodCallRanges.push(methodCallRange);
	}
	
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void {
		expectedMethodCall.setArgumentsMatcher(argumentsMatcher);
	}
	
	public function expectsAnotherMethodCall(Void):Boolean {
		if (!expectedMethodCall) return false;
		if (methodCallRanges.length < 1) {
			if (actualMethodCalls.length < 1) return true;
			else return false;
		}
		return (getCurrentMethodCallRangeIndex() > -1)
	}
	
	private function getCurrentMethodCallRangeIndex(Void):Number {
		var maximum:Number = 0;
		for (var i:Number = 0; i < methodCallRanges.length; i++) {
			var methodCallRange:MethodCallRange = methodCallRanges[i];
			if (methodCallRange) {
				maximum += methodCallRange.getMaximum();
			} else {
				maximum += Number.POSITIVE_INFINITY;
			}
			if (actualMethodCalls.length < maximum) {
				return i;
			}
		}
		return -1;
	}
	
	public function response(Void) {
		return MethodResponse(methodResponses[getCurrentMethodResponseIndex()]).response();
	}
	
	private function getCurrentMethodResponseIndex(Void):Number {
		var maximum:Number = 0;
		for (var i:Number = 0; i < methodCallRanges.length; i++) {
			maximum += MethodCallRange(methodCallRanges[i]).getMaximum();
			if (actualMethodCalls.length <= maximum) {
				return i;
			}
		}
		return -1;
	}
	
	public function verify(Void):Void {
		if (actualMethodCalls.length < getTotalMinimumMethodCallCount()) {
			var error:MethodCallRangeError = new MethodCallRangeError("Expectation failure on verify", this, arguments);
			error.addMethodCall(expectedMethodCall, new MethodCallRange(getTotalMinimumMethodCallCount(), getTotalMaximumMethodCallCount()), new MethodCallRange(actualMethodCalls.length));
			throw error;
		}
		//if (!testCase) throw new IllegalArgumentException("Test case is not allowed to be null or undefined, because method behaviour cannot be verified then.", this, arguments);
		/*if (expectedMethodCall && methodCallRanges < 1) {
			var message:String = "";
			if (!expectedMethodCall.matches(actualMethodCalls[i])) {
				message += "Mismatching method call:";
				message += "\n  expected method call: " + expectedMethodCall;
				message += "\n  actual method call:   " + actualMethodCall;
			}
			if (actualMethodCalls.length > 1) {
				message += "Unexpected method call(s):";
				for (var i:Number = 1; i < actualMethodCalls.length; i++) {
					message += "\n  " + actualMethodCalls[i];
				}
			}
			testCase["fail"](message);
		}*/
		/*if (expectedMethodCall) {
			var maximum:Number = 0;
			for (var i:Number = 0; i < methodCallRanges.length; i++) {
				maximum += MethodCallRange(methodCallRanges[i]).getMaximum();
				if (actualMethodCalls.length > maximum && i == methodCallRanges.length-1) {
					var message:String = "Unexpected Method Calls:";
					for (var k:Number = maximum; k < actualMethodCalls.length; k++) {
						message += "\n  " + actualMethodCalls[k];
					}
					testCase["fail"](message);
				} else if (actualMethodCalls.length < maximum-MethodCallRange(methodCallRanges[i]).getMaximum()+MethodCallRange(methodCallRanges[i]).getMinimum()
						&& MethodCallRange(methodCallRanges[i]).getMinimum() != MethodCallRange.ANY_QUANTITY) {
					testCase["fail"]("Expected method call range [" + methodCallRanges[i] + "] has not been met.");
				}
			}
			return;*/
			/*testCase["assertTrue"](expectedMethodCall.getMethodName() + "(" + expectedMethodCall.getArguments() + "): Expected method call ranges " + methodCallRanges + " have not been met. Actual number of method calls have been: " + actualMethodCalls.length + ".", expectedRange.contains(actualMethodCalls.length));
			// Case that can never happen!
			for (var i:Number = 0; i < actualMethodCalls.length; i++) {
				testCase["assertTrue"](expectedMethodCall.getMethodName() + ": Expected call [" + expectedMethodCall + "] does not match actual call [" + actualMethodCalls[i] + "].", expectedMethodCall.matches(actualMethodCalls[i]));
			}
		}*/
		/*if (actualMethodCalls.length < 0) {
			var message:String = "Unexpected Method Calls:";
			for (var i:Number = 0; i < actualMethodCalls.length; i++) {
				message += "\n  " + actualMethodCalls[i];
			}
			testCase["fail"](message);
			return;
		}
		testCase["fail"]("Unexpected method behaviour, that has no expected method call and no actual method calls.");*/
	}
	
}