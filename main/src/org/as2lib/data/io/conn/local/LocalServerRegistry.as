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
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.io.conn.local.ServerRegistry;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.ExtendedLocalConnection;

/**
 * Implementation of a ServerRegistry to handle all existing LocalServer
 * in one Flash movie. 
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */

class org.as2lib.data.io.conn.local.LocalServerRegistry extends BasicClass implements ServerRegistry {
	/** Contains all registered LocalServer */
	private var serverMap:HashMap;
	
	/**
	 * LocalServer constructor.
	 */
	public function LocalServerRegistry(Void) {
		serverMap = new HashMap();
	}
	
	/**
	 * @see org.as2lib.data.io.conn.local.ServerRegistry#contains()
	 */
	public function contains(host:String):Boolean {
		return ExtendedLocalConnection.connectionExists(host);
	}
	
	/**
	 * @see org.as2lib.data.io.conn.local.ServerRegistry#register()
	 */
	public function register(server:LocalServer):Void {
		var lc = new ExtendedLocalConnection();
		try {
			lc.connect(server.getHost());
		} catch (e:org.as2lib.data.io.conn.local.ReservedConnectionException) {
			throw (new ReservedHostException("Connection with host [" + server.getHost() + "] is already in use.", this, arguments)).initCause(e);
		}
		serverMap.put(server.getHost(), lc);
	}
	
	/**
	 * @see org.as2lib.data.io.conn.local.ServerRegistry#remove()
	 */
	public function remove(server:LocalServer):Void {
		if(serverMap.containsKey(server.getHost())){
			var lc:ExtendedLocalConnection = ExtendedLocalConnection(serverMap.get(server.getHost()));
			lc.close();
			serverMap.remove(server.getHost());
		}
		throw new IllegalArgumentException("You tried to remove a server [" + server + "] with host [" + server.getHost() + "] from the registry that has not been registered.",
										   this,
										   arguments);
	}
}