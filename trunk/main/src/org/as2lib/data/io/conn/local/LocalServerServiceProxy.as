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
import org.as2lib.data.io.conn.local.ExtendedLocalConnection;
import org.as2lib.env.overload.Overload;
import org.as2lib.data.io.conn.local.LocalUtil;

/**
 * Proxy handles client request to a certain service and its response.
 * services, which are availiable after server is started.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */

class org.as2lib.data.io.conn.local.LocalServerServiceProxy extends BasicClass {
	/** Service object/instance */
	private var service;
	
	/** Service name */
	private var name:String;
	
	/** Server identifier */
	private var host:String;
	
	/** service object/instance */
	private var connection:ExtendedLocalConnection;
	
	/**
	 * Initializes Instance.
	 *
	 * @param service object/instance, which provides the service
	 * @param name name of the service
	 * @param host server identifier
	 */
	public function LocalServerServiceProxy(service, name:String, host:String) {
		this.service = service;
		this.name = name;
		this.host = host;
		connection = new ExtendedLocalConnection(this);
	}
	
	/**
	 * Starts the specific service and listens for requests of clients.
	 *
	 * @use org.as2lib.data.io.conn.local.SimpleLocalServer#run()
	 */
	public function run(Void):Void {
		connection.connect(LocalUtil.generateServiceId(host,name));
	}
	
	/**
	 * Stops the specific service.
	 *
	 * @use org.as2lib.data.io.conn.local.SimpleLocalServer#stop()
	 */
	public function stop(Void):Void {
		connection.close();
	}
	
	/**
	 * Method is called if a client tries to use a service.
	 * Handles client request and calls the method of the specific service.
	 * Uses the correct proxy method for passed arguments.
	 */
	public function remoteCall() {
		var o:Overload = new Overload(this);
		o.addHandler([String, Array, String], remoteCallWithResponse);
		o.addHandler([String, Array], remoteCallWithoutResponse);
		o.forward(arguments);
	}
	
	/**
	 * Calls the service method on the service object and returns result
	 * to client.
	 *
	 * @param method method of the service to be called.
	 * @param args arguments, which are passed to the method
	 * @param callback connection name to which response is sent.
	 */
	public function remoteCallWithResponse(method:String, args:Array, callback:String):Void {
		var response = service[method].apply(service, args);
		var responseConnection:ExtendedLocalConnection = new ExtendedLocalConnection();
		responseConnection.send(callback, "onResponse", [response]);
	}
	
	/**
	 * Calls the service method on the service object.
	 *
	 * @param method method of the service to be called.
	 * @param args arguments, which are passed to the method
	 */
	public function remoteCallWithoutResponse(method:String, args:Array):Void {
		service[method].apply(service, args);
	}
}