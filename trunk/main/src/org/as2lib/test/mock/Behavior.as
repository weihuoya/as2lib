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
import org.as2lib.test.mock.MethodBehavior;
import org.as2lib.test.mock.MethodCall;

/**
 * @author Simon Wacker
 */
interface org.as2lib.test.mock.Behavior extends BasicInterface {
	
	/**
	 * Adds a new method behavior for the passed-in method.
	 *
	 * @param methodName the method name to register the method behavior for
	 * @param methodBehavior the method behavior to register
	 */
	public function addMethodBehavior(methodName:String, methodBehavior:MethodBehavior):Void;
	
	/**
	 * Creates a new method behavior for the expected method call.
	 *
	 * @param expectedMethodCall the method call to create a behavior for
	 * @return the newly created method behavior
	 */
	public function createMethodBehavior(expectedMethodCall:MethodCall):MethodBehavior;
	
	/**
	 * Returns the method behavior that matches the given actual method
	 * call.
	 *
	 * @return a matching method behavior
	 */
	public function getMethodBehavior(actualMethodCall:MethodCall):MethodBehavior;
	
	/**
	 * @return the lastly added method behavior
	 */
	public function getLastMethodBehavior(Void):MethodBehavior;
	
	/**
	 * Removes all added behaviors.
	 */
	public function removeAllBehavior(Void):Void;
	
	/**
	 * Verifies every behavior.
	 */
	public function verify(Void):Void;
	
}