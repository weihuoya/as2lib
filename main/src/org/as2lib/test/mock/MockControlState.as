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

import org.as2lib.core.BasicInterface;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * @author Simon Wacker
 */
interface org.as2lib.test.mock.MockControlState extends BasicInterface {
	
	/**
	 * Gets called when a method is called on the mock proxy.
	 *
	 * @param methodName the name of the called method
	 * @param args the passed-in arguments of the called method
	 * @return the return value of the method invocation
	 * @throws Object if the method is set up to throw a throwable
	 */
	public function invokeMethod(call:MethodCall);
	
	/**
	 * Records that the mock object will expect the last method call the
	 * specified number of times, and will react by either returning the
	 * return value, throwing an exception or just doing nothing.
	 *
	 * @param response handles incoming requests appropriately
	 * @param range stores the minimum and maximum quantity of method calls
	 */ 
	public function setResponse(response:MethodResponse, range:MethodCallRange):Void;
	
	/**
	 * Sets the arguments matcher that will be used for the last method specified
	 * by a method call.
	 *
	 * @param argumentsMatcher the arguments matcher to use for the specific method
	 */
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void;

	/**
	 * Verifies that all expectations have been met.
	 *
	 * @param testCase test case to call assert methods on
	 * @throws org.as2lib.test.mock.AssertionFailedError if any expectation has not been met
	 */
	public function verify(testCase:TestCase):Void;
	
}