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
import org.as2lib.test.unit.TestCase;
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
		actualMethodCalls.push(actualMethodCall);
	}
	
	public function addMethodResponse(methodResponse:MethodResponse, methodCallRange:MethodCallRange):Void {
		methodResponses.push(methodResponse);
		methodCallRanges.push(methodCallRange);
	}
	
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void {
		expectedMethodCall.setArgumentsMatcher(argumentsMatcher);
	}

	public function expectsAnotherMehodCall(Void):Boolean {
		return (getCurrentMethodCallRangeIndex() > -1)
	}
	
	private function getCurrentMethodCallRangeIndex(Void):Number {
		var maximum:Number = 0;
		for (var i:Number = 0; i < methodCallRanges.length; i++) {
			maximum += MethodCallRange(methodCallRanges[i]).getMaximum();
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
	
	/*private function getTotalExpectedMethodCallNumber(Void):Void {
		var result:Number = 0;
		for (var i:Number = 0; i < methodCallRanges.length; i++) {
			result += MethodCallRange(methodCallRanges[i]).getMaximum();
		}
		return result;
	}*/
	
	public function verify(testCase:TestCase):Void {
		if (expectedMethodCall) {
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
					testCase["fail"]("Method call range [" + methodCallRanges[i] + "] has not been met.");
				}
			}
			/*testCase["assertTrue"](expectedMethodCall.getMethodName() + "(" + expectedMethodCall.getArguments() + "): Expected method call ranges " + methodCallRanges + " have not been met. Actual number of method calls have been: " + actualMethodCalls.length + ".", expectedRange.contains(actualMethodCalls.length));
			// Case that can never happen!
			for (var i:Number = 0; i < actualMethodCalls.length; i++) {
				testCase["assertTrue"](expectedMethodCall.getMethodName() + ": Expected call [" + expectedMethodCall + "] does not match actual call [" + actualMethodCalls[i] + "].", expectedMethodCall.matches(actualMethodCalls[i]));
			}*/
		} else {
			var message:String = "Unexpected Method Calls:";
			for (var i:Number = 0; i < actualMethodCalls.length; i++) {
				message += "\n  " + actualMethodCalls[i];
			}
			testCase["fail"](message);
		}
	}
	
}