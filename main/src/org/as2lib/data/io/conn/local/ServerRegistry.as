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
import org.as2lib.data.io.conn.local.LocalServer;

/**
 * Interface for a standardized ServerRegistry.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */

interface org.as2lib.data.io.conn.local.ServerRegistry extends BasicInterface {
	
	/**
	 * Checks if a server with passed host already exists.
	 *
	 * @param host name of server
	 */
	public function contains(host:String):Boolean;
	
	/**
	 * Register passed LocalServer at ServerRegistry.
	 *
	 * @param server a LocalServer instance
	 */
	public function register(server:LocalServer):Void;
	
	/**
	 * Removes passed LocalServer from ServerRegistry.
	 *
	 * @param server a LocalServer instance
	 */
	public function remove(server:LocalServer):Void;
}