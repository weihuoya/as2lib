/*
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
import org.as2lib.io.conn.core.event.MethodInvocationReturnInfo;
import org.as2lib.io.conn.core.event.MethodInvocationErrorInfo;

/**
 * MethodInvocationCallback awaits the response of a remote method
 * invocation.
 *
 * <p>There are two types of responses.
 * <dl>
 *   <dt>Return response:</dt>
 *   <dd>Indicates that the method was invoked successfully without
 *       throwing an exception.</dd>
 *   <dt>Error response:</dt>
 *   <dd>Indicates that an error occured when trying to invoke the method.
 *       That error can be an exception the method threw or
 *       the unavailability of the method to invoke.</dd>
 * </dl>
 *
 * <p>Depending on the client and remote service used, that are
 * responsible to propagate this callback methods, there may be other
 * circumstances the specific callback method gets invoked.
 * 
 * <p>This interface can either be instantiated directly or implemented
 * by a class. If you instantiate it directly you must overwrite the
 * callback methods you wanna get informed of with anonymous functions.
 * <code>
 * var callback:MethodInvocationCallback = new MethodInvocationCallback();
 * callback.onReturn = function(returnInfo:MethodInvocationReturnInfo):Void) {
 *   trace("Invoked method successfully: " + returnInfo); 
 * }
 * callback.onError = function(errorInfo:MethodInvocationErrorInfo):Void {
 *   trace("Error occured when trying to invoke the method: " + errorInfo);
 * }
 * </code>
 *
 * <p>Implementing the interface by a class is a much neater way. But
 * sometimes it adds unnecessary complexity.
 * <code>
 * class MyCallback implements MethodInvocationCallback {
 *   public function onReturn(returnInfo:MethodInvocationReturnInfo):Void {
 *     trace("Invoked method successfully: " + returnInfo); 
 *   }
 *   public function onError(errorInfo:MethodInvocationErrorInfo):Void {
 *     trace("Error occured when trying to invoke the method: " + errorInfo);
 *   }
 * }
 * </code>
 *
 * @author Simon Wacker
 */
interface org.as2lib.io.conn.core.event.MethodInvocationCallback extends BasicInterface {
	
	/**
	 * Gets executed when the return value of the method invocation arrives.
	 *
	 * <p>That indicates that the method was invoked successfully.
	 *
	 * @param returnInfo contains the return value and some other useful 
	 *                   information about the invoked method
	 */
	public function onReturn(returnInfo:MethodInvocationReturnInfo):Void;
	
	/**
	 * Gets executed when a method invocation fails.
	 *
	 * <p>Known issues are:
	 * <ul>
	 *   <li>The method threw an exception.</li>
	 *   <li>The method does not exist on the remote service.</li>
	 * </ul>
	 *
	 * <p>Remember that not all clients support this functionalities.
	 *
	 * @param errorInfo contains information about the error and some useful
	 *                  information about the 'invoked' method
	 */
	public function onError(errorInfo:MethodInvocationErrorInfo):Void;
	
}