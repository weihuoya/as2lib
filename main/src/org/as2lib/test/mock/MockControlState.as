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
import org.as2lib.test.mock.MethodCallRange;
import org.as2lib.test.mock.MethodCall;
import org.as2lib.test.mock.MethodResponse;
import org.as2lib.test.mock.ArgumentsMatcher;

/**
 * The actual behavior of the specific methods depends largely on the
 * implementing state. Thus refer to these implementation classes.
 *
 * @author Simon Wacker
 */
interface org.as2lib.test.mock.MockControlState extends BasicInterface {
	
	/**
	 * Gets called when a method is called on the mock proxy.
	 *
	 * @param call contains all information about the method call
	 * @return replay state: the return value of the method invocation
	 * @throws replay state: Object if the method is set up to throw a throwable
	 */
	public function invokeMethod(call:MethodCall);
	
	/**
	 * <dl>
	 *   <dt>Record State:</dt>
	 *   <dd>Records that the mock object will expect the last method call the
	 *       specified number of times, and will react by either returning the
	 *       return value, throwing an exception or just doing nothing.</dd>
	 *   <dt>Replay State:</dt>
	 *   <dd>Throws an IllegalStateException.</dd>
	 * </dl>
	 *
	 * @param methodResponse handles incoming requests appropriately
	 * @param methodCallRange stores the minimum and maximum quantity of method calls
	 * @throws replay state: IllegalArgumentException
	 */ 
	public function setMethodResponse(methodResponse:MethodResponse, methodCallRange:MethodCallRange):Void;
	
	/**
	 * <dl>
	 *   <dt>Record State:</dt>
	 *   <dd>Sets the arguments matcher that will be used for the last method specified
	 *       by a method call.</dd>
	 *   <dt>Replay State:</dt>
	 *   <dd>Throws an IllegalStateException.</dd>
	 * </dl>
	 *
	 * @param argumentsMatcher the arguments matcher to use for the specific method
	 * @throws replay state: IllegalStateException
	 */
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void;

	/**
	 * <dl>
	 *   <dt>Replay State:</dt>
	 *   <dd>Verifies that all expectations have been met.</dd>
	 *   <dt>Record State:</dt>
	 *   <dd>Throws an IllegalStateException.</dd>
	 *
	 * @throws replay state: org.as2lib.test.mock.AssertionFailedError if any expectation has not been met
	 * @throws record state: IllegalArgumentException
	 */
	public function verify(Void):Void;
	
}