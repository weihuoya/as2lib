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
import org.as2lib.test.mock.MethodBehavior;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.DefaultMethodBehavior extends BasicClass implements MethodBehavior {
	
	/** Stores the expected method call. */
	private var expectedMethodCall:MethodCall;
	
	/** Stores the actual method calls. */
	private var actualMethodCalls:Array;
	
	/** Stores the method call ranges. */
	private var methodCallRanges:Array;
	
	/** Stores the method responses. */
	private var methodResponses:Array;
	
	/**
	 * Constructs a new DefaultMethodBehavior instance with the passed-in
	 * method call.
	 *
	 * <p>An expected method call of value null or undefined means
	 * that this behavior expects no actual method calls.
	 * 
	 * @param expectedMethodCall the expected method call this behavior registers expectations, actual calls and responses for
	 */
	public function DefaultMethodBehavior(expectedMethodCall:MethodCall) {
		this.expectedMethodCall = expectedMethodCall;
		actualMethodCalls = new Array();
		methodCallRanges = new Array();
		methodResponses = new Array();
	}
	
	/**
	 * @see MethodBehavior#getExpectedMethodCall(Void):MethodCall
	 */
	public function getExpectedMethodCall(Void):MethodCall {
		return expectedMethodCall;
	}
	
	/**
	 * Adds an actual method call.
	 *
	 * <p>The method call gets added if it is not null, undefined and if
	 * if matches the expected method call.
	 *
	 * @param actualMethodCall the new actual method call to add
	 * @throws IllegalArgumentException if the passed-in method call is null or undefined
	 * @throws AssertionFailedError if no method call was expected
	 *                              if the actual method call does not match the expected method call
	 *                              if the total maximum call count has been passed
	 */
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
	
	/**
	 * @return the total minimum call count
	 */
	private function getTotalMinimumMethodCallCount(Void):Number {
		if (!expectedMethodCall) return 0;
		if (methodCallRanges.length < 1) return 1;
		var result:Number = 0;
		for (var i:Number = 0; i < methodCallRanges.length; i++) {
			result += MethodCallRange(methodCallRanges[i]).getMinimum();
		}
		return result;
	}
	
	/**
	 * @return the total maximum call count
	 */
	private function getTotalMaximumMethodCallCount(Void):Number {
		if (!expectedMethodCall) return 0;
		if (methodCallRanges.length < 1) return 1;
		var result:Number = 0;
		for (var i:Number = 0; i < methodCallRanges.length; i++) {
			result += MethodCallRange(methodCallRanges[i]).getMaximum();
		}
		return result;
	}

	/**
	 * @throws IllegalStateException if the expected method call is null or undefined
	 * @see MethodBehavior#addMethodResponse(MethodResponse, MethodCallRange):Void
	 */
	public function addMethodResponse(methodResponse:MethodResponse, methodCallRange:MethodCallRange):Void {
		if (!expectedMethodCall) throw new IllegalStateException("It is not possible to set a response for an not-expected method call.", this, arguments);
		methodResponses.push(methodResponse);
		methodCallRanges.push(methodCallRange);
	}
	
	/**
	 * @see MethodBehavior#addArgumentsMatcher(ArgumentsMatcher):Void
	 */
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void {
		expectedMethodCall.setArgumentsMatcher(argumentsMatcher);
	}
	
	/**
	 * Returns false if the expected method call is null or undefined.
	 * @see MethodBehavior#expectsAnotherMethodCall(Void):Boolean
	 */
	public function expectsAnotherMethodCall(Void):Boolean {
		if (!expectedMethodCall) return false;
		if (methodCallRanges.length < 1) {
			if (actualMethodCalls.length < 1) return true;
			else return false;
		}
		return (getCurrentMethodCallRangeIndex() > -1)
	}
	
	/**
	 * @return the current position in the method call range array
	 */
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
	
	/**
	 * @see MethodBehavior#response(Void)
	 */
	public function response(Void) {
		return MethodResponse(methodResponses[getCurrentMethodResponseIndex()]).response();
	}
	
	/**
	 * @return the current position in the method response array
	 */
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
	
	/**
	 * @see MethodBehavior#verify(Void):Void
	 */
	public function verify(Void):Void {
		if (actualMethodCalls.length < getTotalMinimumMethodCallCount()) {
			var error:MethodCallRangeError = new MethodCallRangeError("Expectation failure on verify", this, arguments);
			error.addMethodCall(expectedMethodCall, new MethodCallRange(getTotalMinimumMethodCallCount(), getTotalMaximumMethodCallCount()), new MethodCallRange(actualMethodCalls.length));
			throw error;
		}
	}
	
}