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
import org.as2lib.io.conn.core.server.ServerRegistry;
import org.as2lib.io.conn.core.server.ReservedHostException;
import org.as2lib.io.conn.local.core.EnhancedLocalConnection;

/**
 * Implementation of a ServerRegistry to handle all existing Servers.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.io.conn.local.server.LocalServerRegistry extends BasicClass implements ServerRegistry {
	
	/** Contains all registered Servers. */
	private var serverRegistry:Object;
	
	/**
	 * Constructs a new LocalServerRegistry.
	 */
	public function LocalServerRegistry(Void) {
		serverRegistry = new Object();
	}
	
	/**
	 * @see org.as2lib.io.conn.local.ServerRegistry#containsServer()
	 */
	public function containsServer(host:String):Boolean {
		return EnhancedLocalConnection.connectionExists(host);
	}
	
	/**
	 * @throws IllegalArgumentException if the host is null, undefined or a blank string
	 * @throws ReservedHostException if a server with the passed-in host is already running
	 * @see org.as2lib.io.conn.local.ServerRegistry#registerServer()
	 */
	public function registerServer(host:String):Void {
		if (!host) throw new IllegalArgumentException("Host must not be null, undefined or a blank string.", this, arguments);
		var connection:EnhancedLocalConnection = new EnhancedLocalConnection();
		try {
			connection.connect(host);
		} catch(exception:org.as2lib.io.conn.local.core.ReservedConnectionException) {
			throw new ReservedHostException("Server with host [" + host + "] is already running.", this, arguments).initCause(exception);
		}
		serverRegistry[host] = connection;
	}
	
	/**
	 * @throws IllegalArgumentException if you tried to unregister a server that has not been registered directly at this registry but at another one
	 * @see org.as2lib.io.conn.local.ServerRegistry#removeServer()
	 */
	public function removeServer(host:String):Void {
		if (serverRegistry[host]) {
			var connection:EnhancedLocalConnection = serverRegistry[host];
			connection.close();
			serverRegistry[host] = undefined;
			return;
		}
		if (containsServer(host)) {
			throw new IllegalArgumentException("Local server registry can only remove servers that have been registered directly at it. Host [" + host + "] has been registered at another registry.", this, arguments);
		}
	}
	
}