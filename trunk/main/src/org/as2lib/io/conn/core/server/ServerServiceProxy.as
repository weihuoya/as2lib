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
import org.as2lib.io.conn.core.event.MethodInvocationErrorListener;

/**
 * ServerServiceProxy handles client request to a certain service and 
 * its response.
 *
 * @author Simon Wacker
 * @author Christoph Atteneder
 */
interface org.as2lib.io.conn.core.server.ServerServiceProxy extends BasicInterface {
	
	/**
	 * Runs the service and listens for requests of clients.
	 *
	 * @param host the host to run the service on
	 */
	public function run(host:String):Void;
	
	/**
	 * Stops the service.
	 */
	public function stop(Void):Void;
	
	/**
	 * @overload #invokeMethodByNameAndArguments
	 * @overload #invokeMethodByNameAndArgumentsAndResponseService
	 */
	public function invokeMethod():Void;
	
	/**
	 * Invokes the service method on the service object.
	 *
	 * @param methodName the name of the service's method to be invoked
	 * @param args arguments to be passed to the method
	 */
	public function invokeMethodByNameAndArguments(methodName:String, args:Array):Void;
	
	/**
	 * Invokes the service method on the service object and returns the
	 * response to the client using the response service.
	 *
	 * @param methodName name of method to be invoked on the service
	 * @param args arguments to be passed to the method
	 * @param responseServiceUrl the url of response service to which the result gets sent
	 */
	public function invokeMethodByNameAndArgumentsAndResponseService(methodName:String, args:Array, responseServiceUrl:String):Void;
	
	/**
	 * Returns the original service, this proxy wraps.
	 *
	 * @return the original service
	 */
	public function getService(Void);
	
	/**
	 * Returns the path on the host of the service.
	 *
	 * @return the path of the service
	 */
	public function getPath(Void):String;
	
	/**
	 * Indicates whether the service is currently running.
	 *
	 * @return true if the service runs else false
	 */
	public function isRunning(Void):Boolean;
	
	/**
	 * Adds a new error listener to listen for errors that might occur
	 * when trying to invoke the method on the service.
	 *
	 * @param errorListener the error listener to add
	 */
	public function addErrorListener(errorListener:MethodInvocationErrorListener):Void;
	
	/**
	 * Removes an added error listener.
	 *
	 * @param errorListener the error listener to remove
	 */
	public function removeErrorListener(errorListener:MethodInvocationErrorListener):Void;
	
}