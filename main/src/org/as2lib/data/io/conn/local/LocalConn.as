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
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.data.io.conn.Connection;
import org.as2lib.data.io.conn.ServiceProxy;
import org.as2lib.data.io.conn.local.LocalClientServiceProxy;
import org.as2lib.data.io.conn.local.LocalUtil;
import org.as2lib.data.io.conn.local.LocalConfig;
import org.as2lib.data.io.conn.local.ExtendedLocalConnection;
import org.as2lib.data.io.conn.local.UnknownHostException;
import org.as2lib.data.io.conn.local.UnknownServiceException;

/**
 * Provides basic functionalities of a as2lib Connection.
 * You use the LocalConn, if you want to connect to a remote
 * LocalConnection service.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */

class org.as2lib.data.io.conn.local.LocalConn extends BasicClass implements Connection {
	/** host you want to connect to */
	private var host:String;
	/** shows if LocalConn is already established */
	private var opened:Boolean;
	
	/** 
	 * Constructor
	 * 
	 * @param host to which the connection should be established
	 */
	public function LocalConn(host:String) {
		this.host = host;
		opened = false;
	}
	
	/**
	 * Generates a Proxy object to a specific service.
	 * throws UnknownServiceException and IllegalStateException
	 * 
	 *@param service for which a Proxy should be created to 
	 */
	public function getProxy(service:String):ServiceProxy {
		if (opened) {
			if (!ExtendedLocalConnection.connectionExists(LocalUtil.generateServiceId(host, service))) {
				throw new UnknownServiceException("The service [" + service + "] on host [" + host + "] does not exist.", this, arguments);
			}
			return (new LocalClientServiceProxy(LocalUtil.generateServiceId(host, service)));
		}
		throw new IllegalStateException("You must call the #open() operation before calling #getProxy().", this, arguments);
	}
	
	/**
	 * Establishes a LocalConnection to a running server.
	 * throws UnknownHostException
	 */
	public function open(Void):Void {
		if (!ExtendedLocalConnection.connectionExists(host)) {
			throw new UnknownHostException("The server with host [" + host + "] is not available.", this, arguments);
		}
		opened = true;
	}
	
	/**
	 * Closes a LocalConn
	 */
	public function close(Void):Void {
		opened = false;
	}
}