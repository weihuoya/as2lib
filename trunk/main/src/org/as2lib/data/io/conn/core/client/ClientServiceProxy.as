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
import org.as2lib.data.io.conn.core.event.MethodInvocationCallback;

/**
 * Interface for standardized ClientServiceProxys to handle client requests to a
 * certain service on a server and its response.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
interface org.as2lib.data.io.conn.core.client.ClientServiceProxy extends BasicInterface {
	
	/**
	 * @overload #invokeByName()
	 * @overload #invokeByNameAndArguments()
	 * @overload #invokeByNameAndCallback()
	 * @overload #invokeByNameAndArgumentsAndCallback()
	 */
	public function invoke():Void;
	
	/**
	 * Invokes the given method by name passing no arguments.
	 *
	 * @param name the name of the method to be invoked
	 */
	public function invokeByName(name:String):Void;
	
	/**
	 * Invokes the given method by name passing the given arguments.
	 *
	 * @param name the name of the method to be invoked
	 * @param args the arguments to be passed to the method
	 */
	public function invokeByNameAndArguments(name:String, args:Array):Void;
	
	/**
	 * Invokes the given method by name passing no arguments. When the result
	 * gets returned the appropriate method on MethodInvocationCallback passing the
	 * result will be invoked.
	 *
	 * @param name the name of the method to be invoked
	 * @param callback the call to receive the response or possible failures
	 */
	public function invokeByNameAndCallback(name:String, callback:MethodInvocationCallback):Void;
	
	/**
	 * Invokes the given method by name passing the given arguments. When the result
	 * arrives the appropriate method in MethodInvocationCallback passing the result will
	 * be invoked.
	 *
	 * @param name the name of the method to be invoked
	 * @param call the callback to receive the response or possible failures
	 */
	public function invokeByNameAndArgumentsAndCallback(name:String, args:Array, callback:MethodInvocationCallback):Void;
	
}