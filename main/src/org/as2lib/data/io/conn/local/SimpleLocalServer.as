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
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.LocalConfig;
import org.as2lib.data.io.conn.local.LocalServerServiceProxy;

/**
 * Provides functionalities for adding services,
 * which are availiable after server is started.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */

class org.as2lib.data.io.conn.local.SimpleLocalServer extends BasicClass implements LocalServer {
	/** Identifier of SimpleLocalServer */
	private var host:String;
	/** Contains all services */
	private var serviceArray:Array;
	/** server status */
	private var running:Boolean;
	
	/**
	 * Sets host and initializes serviceArray.
	 *
	 * @param name of server
	 */
	public function SimpleLocalServer(host:String) {
		this.host = host;
		serviceArray = new Array();
		running = false;
	}
	
	/**
	 * @see org.as2lib.data.io.conn.local.LocalServer#run()
	 */
	public function run(Void):Void {
		for (var i:Number = 0; i < serviceArray.length; i++) {
			LocalServerServiceProxy(serviceArray[i]).run();
		}
		LocalConfig.getServerRegistry().register(this);
		running = true;
	}
	
	/**
	 * @see org.as2lib.data.io.conn.local.LocalServer#stop()
	 */
	public function stop(Void):Void {
		for (var i:Number = 0; i < serviceArray.length; i++) {
			LocalServerServiceProxy(serviceArray[i]).stop();
		}
		LocalConfig.getServerRegistry().remove(this);
		running = false;
	}
	
	/**
	 * @see org.as2lib.data.io.conn.local.LocalServer#putService()
	 */
	public function putService(name:String, service):Void {
		serviceArray.push(new LocalServerServiceProxy(service, name, host));
	}
	
	/**
	 * @see org.as2lib.data.io.conn.local.LocalServer#isRunning()
	 */
	public function isRunning(Void):Boolean {
		return running;
	}
	
	/**
	 * @see org.as2lib.data.io.conn.local.LocalServer#getHost()
	 */
	public function getHost(Void):String {
		return host;
	}
}