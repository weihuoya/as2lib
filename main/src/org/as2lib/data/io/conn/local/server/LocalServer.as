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
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.data.io.conn.core.server.Server;
import org.as2lib.data.io.conn.core.server.ServerServiceProxy;
import org.as2lib.data.io.conn.local.LocalConfig;
import org.as2lib.data.io.conn.local.server.LocalServerServiceProxy;

/**
 * Provides functionalities for adding services,
 * which are availiable after the server is started.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.data.io.conn.local.server.LocalServer extends BasicClass implements Server {
	
	/** Name of the server. */
	private var host:String;
	
	/** Contains all services. */
	private var services:Map;
	
	/** Server status. */
	private var running:Boolean;
	
	/**
	 * Constructs a new LocalServer instance.
	 *
	 * @param host the name of server
	 */
	public function LocalServer(host:String) {
		this.host = host;
		services = new PrimitiveTypeMap();
		running = false;
	}
	
	/**
	 * @see Server#run()
	 */
	public function run(Void):Void {
		LocalConfig.getServerRegistry().register(this);
		var serviceArray:Array = services.getValues();
		for (var i:Number = 0; i < serviceArray.length; i++) {
			ServerServiceProxy(serviceArray[i]).run(host);
		}
		running = true;
	}
	
	/**
	 * @see Server#stop()
	 */
	public function stop(Void):Void {
		var serviceArray:Array = services.getValues();
		for (var i:Number = 0; i < serviceArray.length; i++) {
			ServerServiceProxy(serviceArray[i]).stop();
		}
		LocalConfig.getServerRegistry().remove(this);
		running = false;
	}
	
	/**
	 * @see Server#putService()
	 */
	public function putService(path:String, service):Void {
		// source out instantiation
		addService(new LocalServerServiceProxy(path, service));
	}
	
	/**
	 * @see Server#addService()
	 */
	public function addService(proxy:ServerServiceProxy):Void {
		services.put(proxy.getPath(), proxy);
		if (isRunning()) {
			proxy.run();
		}
	}
	
	/**
	 * @see Server#removeService()
	 */
	public function removeService(path:String):ServerServiceProxy {
		return services.remove(path);
	}
	
	/**
	 * @see Server#getService()
	 */
	public function getService(path:String):ServerServiceProxy {
		return services.get(path);
	}
	
	/**
	 * @see Server#isRunning()
	 */
	public function isRunning(Void):Boolean {
		return running;
	}
	
	/**
	 * @see Server#getHost()
	 */
	public function getHost(Void):String {
		return host;
	}
	
}