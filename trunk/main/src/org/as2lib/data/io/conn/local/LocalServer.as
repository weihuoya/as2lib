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

/**
 * Interface for standardized LocalServers.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */

interface org.as2lib.data.io.conn.local.LocalServer extends BasicInterface {
	/**
	 * Starts added services and registers server at ServerRegistry.
	 */
	public function run(Void):Void;
	
	/**
	 * Stops added services and removes server from ServerRegistry.
	 */
	public function stop(Void):Void;
	
	/**
	 * Adds a service to the server.
	 * 
	 * @param service is the identifier through which the service can be accessed
	 * @param object is the object/instance, which provides the service
	 */
	public function putService(service:String, object):Void;
	
	/**
	 * Returns name of the server.
	 * 
	 * @return true if server is running/services are availiable
	 */
	public function getHost(Void):String;
	
	/**
	 * Adds a service to the server.
	 * 
	 * @return true if server is running/services are availiable
	 */
	public function isRunning(Void):Boolean;
}