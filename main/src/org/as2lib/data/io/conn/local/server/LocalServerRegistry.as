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
 
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.data.io.conn.core.server.ServerRegistry;
import org.as2lib.data.io.conn.core.server.Server;
import org.as2lib.data.io.conn.core.server.ReservedHostException;
import org.as2lib.data.io.conn.local.core.LocalConnectionTemplate;

/**
 * Implementation of a ServerRegistry to handle all existing Servers.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.data.io.conn.local.server.LocalServerRegistry extends BasicClass implements ServerRegistry {
	
	/** Contains all registered Servers. */
	private var serverRegistry:Object;
	
	/**
	 * Constructs a new LocalServerRegistry.
	 */
	public function LocalServerRegistry(Void) {
		serverRegistry = new Object();
	}
	
	/**
	 * @see org.as2lib.data.io.conn.local.ServerRegistry#contains()
	 */
	public function contains(host:String):Boolean {
		return LocalConnectionTemplate.connectionExists(host);
	}
	
	/**
	 * @see org.as2lib.data.io.conn.local.ServerRegistry#register()
	 */
	public function register(server:Server):Void {
		var connection:LocalConnectionTemplate = new LocalConnectionTemplate();
		try {
			connection.connect(server.getHost());
		} catch(exception:org.as2lib.data.io.conn.local.core.ReservedConnectionException) {
			throw new ReservedHostException("Server with host [" + server.getHost() + "] is already running.", this, arguments).initCause(exception);
		}
		serverRegistry[server.getHost()] = connection;
	}
	
	/**
	 * @see org.as2lib.data.io.conn.local.ServerRegistry#remove()
	 */
	public function remove(server:Server):Void {
		if (serverRegistry[server.getHost()]) {
			var connection:LocalConnectionTemplate = serverRegistry[server.getHost()];
			connection.close();
			serverRegistry[server.getHost()] = undefined;
		}
		throw new IllegalArgumentException("You tried to remove a server [" + server + "] with host [" + server.getHost() + "] from the registry that has not been registered yet.", this, arguments);
	}
	
}