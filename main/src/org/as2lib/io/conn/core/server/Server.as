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
import org.as2lib.io.conn.core.server.ServerServiceProxy;

/**
 * Interface for standardized Servers.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
interface org.as2lib.io.conn.core.server.Server extends BasicInterface {
	
	/**
	 * Starts added services.
	 */
	public function run(Void):Void;
	
	/**
	 * Stops added services.
	 */
	public function stop(Void):Void;
	
	/**
	 * Adds a service to the server.
	 * 
	 * @param path the path through which the service can be accessed on the server
	 * @param service the actual service which provides the functionalities
	 */
	public function putService(path:String, service):ServerServiceProxy;
	
	/**
	 * Adds the service already wrapped into a proxy to the server.
	 *
	 * @param proxy the proxy to be added to the server
	 */
	public function addService(proxy:ServerServiceProxy):Void;
	
	/**
	 * Removes the appropriate service from the server.
	 *
	 * @param path the full path of the service
	 * @return a ServerServiceProxy instance wrapping the original service
	 */
	public function removeService(path:String):ServerServiceProxy;
	
	/**
	 * Returns an added service.
	 *
	 * @param path the full path of the service
	 * @return a ServerServiceProxy instance wrapping the original service
	 */
	public function getService(path:String):ServerServiceProxy;
	
	/**
	 * Returns the name of the server.
	 * 
	 * @return the name of the server
	 */
	public function getHost(Void):String;
	
	/**
	 * Returns whether the server is running.
	 * 
	 * @return true if the server is running
	 */
	public function isRunning(Void):Boolean;
	
}