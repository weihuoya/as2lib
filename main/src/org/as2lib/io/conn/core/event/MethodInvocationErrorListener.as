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

import org.as2lib.env.event.EventListener;
import org.as2lib.io.conn.core.event.MethodInvocationErrorInfo;

/**
 * MethodInvocationErrorListener awaits an error response of a remote
 * method invocation.
 *
 * <p>When and why the callback method gets invoked depends on the client
 * you use.
 *
 * <p>This interface can either be instantiated directly or implemented
 * by a class. If you instantiate it directly you must overwrite the
 * callback method with an anonymous function.
 * <code>
 * var listener:MethodInvocationErrorListener = new MethodInvocationErrorListener();
 * listener.onError = function(errorInfo:MethodInvocationErrorInfo):Void {
 *   trace("Error occured when trying to invoke the method: " + errorInfo);
 * }
 * </code>
 *
 * <p>Implementing the interface by a class is a much neater way. But
 * sometimes adds is unnecessary complexity.
 * <code>
 * class MyListener implements MethodInvocationErrorListener {
 *   public function onError(errorInfo:MethodInvocationErrorInfo):Void {
 *     trace("Error occured when trying to invoke the method: " + errorInfo);
 *   }
 * }
 * </code>
 *
 * @author Simon Wacker
 */
interface org.as2lib.io.conn.core.event.MethodInvocationErrorListener extends EventListener {
	
	/**
	 * Gets executed when the method invocation failed.
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