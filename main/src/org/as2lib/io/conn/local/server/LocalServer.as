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
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.io.conn.core.server.Server;
import org.as2lib.io.conn.core.server.ServerServiceProxy;
import org.as2lib.io.conn.core.server.ServerRegistry;
import org.as2lib.io.conn.core.server.ReservedHostException;
import org.as2lib.io.conn.local.server.LocalServerServiceProxy;
import org.as2lib.io.conn.local.LocalConfig;

/**
 * LocalServer acts as a composite for for many services that all get
 * combined in one domain.
 *
 * <p>The general use case looks as follows:
 * <code>
 * var server:LocalServer = new LocalServer("local.as2lib.org");
 * server.putService("myServiceOne", new MyServiceOne());
 * server.putService("myServiceTwo", new MyServiceTwo());
 * server.run();
 * </code>
 *
 * @author Simon Wacker
 * @author Christoph Atteneder
 */
class org.as2lib.io.conn.local.server.LocalServer extends BasicClass implements Server {
	
	/** Name of the server. */
	private var host:String;
	
	/** Contains all services. */
	private var services:Map;
	
	/** Server status. */
	private var running:Boolean;
	
	/** Stores the server registry. */
	private var serverRegistry:ServerRegistry;
	
	/**
	 * Constructs a new LocalServer instance.
	 *
	 * @param host the name of server
	 * @throws IllegalArgumentException if the passed-in host is null, undefined or an empty string
	 */
	public function LocalServer(host:String) {
		if (!host) throw new IllegalArgumentException("Host must not be null, undefined or a blank string.", this, arguments);
		this.host = host;
		services = new PrimitiveTypeMap();
		running = false;
	}
	
	/**
	 * Returns the currently used server registry.
	 *
	 * <p>That is either the server registry set via #setServerRegistry(ServerRegistry):Void
	 * or the default registry returned by the LocalConfig#getServerRegistry(Void):ServerRegistry
	 * method.
	 *
	 * @return the currently used server registry
	 */
	public function getServerRegistry(Void):ServerRegistry {
		if (!serverRegistry) serverRegistry = LocalConfig.getServerRegistry();
		return serverRegistry;
	}
	
	/**
	 * Sets a new server registry.
	 *
	 * <p>If the new server registry is null or undefined the getServerRegistry(Void):ServerRegistry
	 * method will return the default server registry.
	 *
	 * @param serverRegistry the new server registry
	 */
	public function setServerRegistry(serverRegistry:ServerRegistry):Void {
		this.serverRegistry = serverRegistry;
	}
	
	/**
	 * Registers itself at the server registry and runs all added services
	 * with the host.
	 *
	 * <p>If the server is already running a restart will be made. That means
	 * it will be stopped and run again.
	 *
	 * @see Server#run(Void):Void
	 */
	public function run(Void):Void {
		if (isRunning()) this.stop();
		getServerRegistry().registerServer(getHost());
		if (services.size() > 0) {
			var serviceArray:Array = services.getValues();
			for (var i:Number = 0; i < serviceArray.length; i++) {
				ServerServiceProxy(serviceArray[i]).run(host);
			}
		}
		running = true;
	}
	
	/**
	 * Stops all services and removes itself from the server registry.
	 *
	 * @see Server#stop()
	 */
	public function stop(Void):Void {
		if (services.size() > 0) {
			var serviceArray:Array = services.getValues();
			for (var i:Number = 0; i < serviceArray.length; i++) {
				ServerServiceProxy(serviceArray[i]).stop();
			}
		}
		if (getServerRegistry().containsServer(getHost())) {
			getServerRegistry().removeServer(getHost());
		}
		running = false;
	}
	
	/**
	 * Adds the service for the passed-in path.
	 *
	 * <p>Service and path get wrapped in a ServerServiceProxy instance.
	 * This service proxy may throw an IllegalArgumentException if the
	 * service is null.
	 *
	 * @param path that path to the service on the host
	 * @param service the service to make locally available
	 * @return the newly created server service proxy that wraps the service and the path
	 * @throws IllegalArgumentException if the passed-in path is null, undefined or an empty string
	 * @see Server#putService(String, *):ServerServiceProxy
	 */
	public function putService(path:String, service):ServerServiceProxy {
		// source out instantiation
		var proxy:ServerServiceProxy = new LocalServerServiceProxy(path, service);
		addService(proxy);
		return proxy;
	}
	
	/**
	 * Adds the passed-in service.
	 *
	 * <p>If the server is running, the service proxy will be run too.
	 *
	 * @param proxy the proxy that wraps the actual service
	 * @throws IllegalArgumentException if the passed-in service proxy is null or undefined
	 *                                  if the path of the passed-in service proxy is null, undefined or a blank string
	 *                                  if the path of the passed-in service proxy is already in use
	 * @see Server#addService(ServerServiceProxy):Void
	 */
	public function addService(proxy:ServerServiceProxy):Void {
		if (!proxy) throw new IllegalArgumentException("Service proxy must not be null or undefined.", this, arguments);
		var path:String = proxy.getPath();
		if (!path) throw new IllegalArgumentException("Service proxy's path must not be null, undefined or a blank string.", this, arguments);
		if (services.containsKey(path)) throw new IllegalArgumentException("Service proxy with proxy path [" + path + "] is already in use.", this, arguments);
		services.put(path, proxy);
		if (isRunning()) {
			proxy.run(host);
		}
	}
	
	/**
	 * Removes the service registered for the passed-in path.
	 *
	 * <p>If the service is running it will be stopped.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in path is null or and empty string.</li>
	 *   <li>There is no registered service for the passed-in path.</li>
	 * </ul>
	 *
	 * @param path the path of the service to remove
	 * @return the removed server service proxy wrapping the actual service
	 * @see Server#removeService(String):ServerServiceProxy
	 */
	public function removeService(path:String):ServerServiceProxy {
		if (!path) return null;
		var service:ServerServiceProxy = services.remove(path);
		if (service.isRunning()) service.stop();
		return service;
	}
	
	/**
	 * Returns the service registered for the passed-in path.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in path is null or an empty string.</li>
	 *   <li>There is no service registered for the passed-in path.</li>
	 * </ul>
	 *
	 * @param path the path of the service that gets returned
	 * @return the server service proxy wrapping the actual service
	 * @see Server#getService(String):ServerServiceProxy
	 */
	public function getService(path:String):ServerServiceProxy {
		if (!path) return null;
		return services.get(path);
	}
	
	/**
	 * Returns whether the server is running.
	 *
	 * <p>The server is by default not running. It runs as soon as you call
	 * the #run(Void):Void method. And stops when you call the #stop(Void):Void
	 * method.
	 *
	 * @return true if the server runs else false
	 * @see Server#isRunning(Void):Boolean
	 */
	public function isRunning(Void):Boolean {
		return running;
	}
	
	/**
	 * Returns the host of this server.
	 *
	 * @return this server's host
	 * @see Server#getHost(Void):String
	 */
	public function getHost(Void):String {
		return host;
	}
	
}