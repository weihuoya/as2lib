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
import org.as2lib.io.conn.core.event.MethodInvocationCallback;

/**
 * ClientServiceProxy handles client requests to a certain service and
 * its response.
 *
 * @author Simon Wacker
 * @author Christoph Atteneder
 */
interface org.as2lib.io.conn.core.client.ClientServiceProxy extends BasicInterface {
	
	/**
	 * @overload #invokeByName
	 * @overload #invokeByNameAndArguments
	 * @overload #invokeByNameAndCallback
	 * @overload #invokeByNameAndArgumentsAndCallback
	 */
	public function invoke():MethodInvocationCallback;
	
	/**
	 * Invokes the passed-in method on the service.
	 *
	 * @param methodName the name of the method to invoke
	 * @return a callback that can be used to get informed of the response
	 */
	public function invokeByName(methodName:String):MethodInvocationCallback;
	
	/**
	 * Invokes the passed-in method passing the given arguments.
	 *
	 * @param methodName the name of the method to invoke
	 * @param args the arguments to be passed to the method
	 * @return a callback that can be used to get informed of the response
	 */
	public function invokeByNameAndArguments(methodName:String, args:Array):MethodInvocationCallback;
	
	/**
	 * Invokes the passed-in method on the service.
	 *
	 * <p>When the response arrives the appropriate callback method gets
	 * invoked.
	 *
	 * <p>If the passed-in callback is not null, the returned callback
	 * should be the same.
	 *
	 * @param methodName the name of the method to invoke
	 * @param callback the callback that receives the return value or errors
	 * @return a callback that can be used to get informed of the response
	 */
	public function invokeByNameAndCallback(methodName:String, callback:MethodInvocationCallback):MethodInvocationCallback;
	
	/**
	 * Invokes the passed-in method on the service, passing the arguments.
	 *
	 * <p>When the response arrives the appropriate callback method gets
	 * invoked.
	 *
	 * <p>If the passed-in callback is not null, the returned callback
	 * should be the same.
	 *
	 * @param methodName the name of the method to be invoked
	 * @param args the arguments to pass to the method
	 * @param callback the callback to receive the response or possible failures
	 * @return a callback that can be used to get informed of the response
	 */
	public function invokeByNameAndArgumentsAndCallback(methodName:String, args:Array, callback:MethodInvocationCallback):MethodInvocationCallback;
	
}