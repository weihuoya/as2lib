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

import org.as2lib.test.mock.AssertionFailedError;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodCallRange;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.MethodCallRangeError extends AssertionFailedError {
	
	// Sloppy design. I wanna have inner class support. ;)
	private var methodCalls:Array;
	private var expectedMethodCallRanges:Array;
	private var actualMethodCallRanges:Array;
	
	public function MethodCallRangeError(message:String, thrower, args:FunctionArguments) {
		super(message, thrower, args);
		methodCalls = new Array();
		expectedMethodCallRanges = new Array();
		actualMethodCallRanges = new Array();
	}
	
	public function addMethodCall(methodCall:MethodCall, expectedMethodCallRange:MethodCallRange, actualMethodCallRange:MethodCallRange):Void {
		methodCalls.push(methodCall);
		expectedMethodCallRanges.push(expectedMethodCallRange);
		actualMethodCallRanges.push(actualMethodCallRange);
	}
	
	public function getMessage(Void):String {
		return toString();
	}
	
	public function toString(Void):String {
		var message:String = super.getMessage() + ":";
		for (var i:Number = 0; i < methodCalls.length; i++) {
			message += "\n  " + methodCalls[i] + ": expected: " + expectedMethodCallRanges[i] + ", actual: " + actualMethodCallRanges[i];
		}
		return message;
	}
	
}