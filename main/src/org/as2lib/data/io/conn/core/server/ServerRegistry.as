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
import org.as2lib.data.io.conn.core.server.Server;

/**
 * Interface for a standardized ServerRegistry.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
interface org.as2lib.data.io.conn.core.server.ServerRegistry extends BasicInterface {
	
	/**
	 * Checks if a server with passed host exists.
	 *
	 * @param host the name of server
	 */
	public function contains(host:String):Boolean;
	
	/**
	 * Registers passed Server at ServerRegistry.
	 *
	 * @param server a Server instance
	 */
	public function register(server:Server):Void;
	
	/**
	 * Removes passed Server from ServerRegistry.
	 *
	 * @param server a Server instance
	 */
	public function remove(server:Server):Void;
	
}