﻿/**
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
import org.as2lib.test.mock.MethodCallBehaviour;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.AssertionFailedError;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.DefaultMethodCallBehaviour extends BasicClass implements MethodCallBehaviour {
	
	private var expectedCall:MethodCall;
	private var actualCalls:Array;
	private var expectedRange:MethodCallRange;
	private var responseAttribute:MethodResponse;
	
	/**
	 * Constructs a new instance.
	 */
	public function DefaultMethodCallBehaviour(Void) {
		actualCalls = new Array();
	}
	
	/**
	 * @see MethodCallBehaviour#setExpectedCall()
	 */
	public function setExpectedCall(expectedCall:MethodCall):Void {
		this.expectedCall = expectedCall;
	}
	
	/**
	 * @see MethodCallBehaviour#addActualCall()
	 */
	public function addActualCall(actualCall:MethodCall):Void {
		this.actualCalls.push(actualCall);
	}
	
	/**
	 * @see MethodCallBehaviour#setResponse()
	 */
	public function setResponse(response:MethodResponse):Void {
		this.responseAttribute = response;
	}
	
	/**
	 * @see MethodCallBehaviour#setExpectedRange()
	 */
	public function setExpectedRange(expectedRange:MethodCallRange):Void {
		this.expectedRange = expectedRange;
	}
	
	/**
	 * @see MethodCallBehaviour#response()
	 */
	public function response(Void) {
		return responseAttribute.response();
	}
	
	/**
	 * @see MethodCallBehaviour#verify()
	 */
	public function verify(Void):Void {
		var errorMessage:String = "";
		try {
			expectedRange.verify(actualCalls.length);
		} catch (exception:org.as2lib.test.mock.AssertionFailedError) {
			errorMessage += exception.getMessage() + "\n";
		}
		for (var i:Number = 0; i < actualCalls.length; i++) {
			try {
				expectedCall.verify(actualCalls[i]);
			} catch (exception:org.as2lib.test.mock.AssertionFailedError) {
				errorMessage += exception.getMessage() + "\n";
			}
		}
		if (errorMessage) throw new AssertionFailedError(errorMessage, this, arguments);
	}
	
}