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

import org.as2lib.core.BasicInterface;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * @author Simon Wacker
 */
interface org.as2lib.test.mock.MethodBehavior extends BasicInterface {
	
	/**
	 * @return the expected method call
	 */
	public function getExpectedMethodCall(Void):MethodCall;
	
	/**
	 * Adds a new actual method call.
	 * 
	 * @param actualMethodCall the new actual method call
	 * @throws AssertionFailedException if the maximum number of actual method calls has been passed
	 */
	public function addActualMethodCall(actualMethodCall:MethodCall):Void;
	
	/**
	 * Adds a new method response together with the range that indicates
	 * when the response shall take place.
	 *
	 * <p>If you set no response gets set the behavior expects exactly
	 * one method call.
	 *
	 * @param methodResponse the response to do a given number of times
	 * @param methodCallRange the range that indicates how often the response can take place
	 */
	public function addMethodResponse(methodResponse:MethodResponse, methodCallRange:MethodCallRange):Void;
	
	/**
	 * Sets the arguments matcher for the expected method call.
	 * 
	 * @param argumentsMatcher the arguments matcher for the expected method call
	 */
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void;
	
	/**
	 * Checks whether this behavior expects another method call.
	 *
	 * @return true if a further method call is expected else false
	 */
	public function expectsAnotherMethodCall(Void):Boolean;
	
	/**
	 * Responses depending on the current number of actual method calls.
	 *
	 * @return the response's return value
	 * @throw the response's throwable
	 */
	public function response(Void);
	
	/**
	 * Verifies that the expactations have been met.
	 *
	 * <p>That is that there haven't been to many or to little method calls.
	 * @throws AssertionFailedException if the verification fails
	 */
	public function verify(Void):Void;
	
}