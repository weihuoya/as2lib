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

import org.as2lib.env.overload.Overload;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SpeedEventBroadcaster;

import org.as2lib.data.io.conn.core.server.AbstractServerServiceProxy;
import org.as2lib.data.io.conn.core.server.ServerServiceProxy;
import org.as2lib.data.io.conn.core.server.ReservedServiceException;
import org.as2lib.data.io.conn.core.event.MethodInvocationErrorListener;
import org.as2lib.data.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.data.io.conn.local.core.LocalConnectionTemplate;

/**
 * Proxy handles client request to a certain service and its response.
 * services, which are availiable after server is started.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.data.io.conn.local.server.LocalServerServiceProxy extends AbstractServerServiceProxy implements ServerServiceProxy {
	
	/** Wrapped service object. */
	private var service;
	
	/** Service path. */
	private var path:String;
	
	/** Used to set up the server. */
	private var connection:LocalConnectionTemplate;
	
	/** Stores added MethodInvocationErrorListeners. */
	private var errorBroadcaster:EventBroadcaster;
	
	/** Service status. */
	private var running:Boolean;
	
	/**
	 * Constructs a new LocalServerServiceProxy.
	 *
	 * @param path the path of the service
	 * @param service object which provides the service operations
	 */
	public function LocalServerServiceProxy(path:String, service) {
		this.path = path;
		this.service = service;
		connection = new LocalConnectionTemplate(this);
		errorBroadcaster = new SpeedEventBroadcaster();
	}
	
	/**
	 * @see ServerServiceProxy#run()
	 */
	public function run(host:String):Void {
		try {
			connection.connect(generateServiceUrl(host, path));
			running = true;
		} catch(exception:org.as2lib.data.io.conn.local.core.ReservedConnectionException) {
			throw new ReservedServiceException("Service with path [" + path + "] on host [" + host + "] is already in use.", this, arguments).initCause(exception);
		}
	}
	
	/**
	 * @see ServerServiceProxy#stop()
	 */
	public function stop(Void):Void {
		connection.close();
		running = false;
	}
	
	/**
	 * @see ServerServiceProxy#invokeMethod()
	 */
	public function invokeMethod() {
		var o:Overload = new Overload(this);
		o.addHandler([String, Array], invokeMethodByNameAndArguments);
		o.addHandler([String, Array, String], invokeMethodByNameAndArgumentsAndResponseService);
		o.forward(arguments);
	}
	
	/**
	 * @see ServerServiceProxy#invokeMethodByNameAndArguments()
	 */
	public function invokeMethodByNameAndArguments(name:String, args:Array):Void {
		try {
			if (service[name]) {
				service[name].apply(service, args);
			} else {
				errorBroadcaster.dispatch(new MethodInvocationErrorInfo(path, name, MethodInvocationErrorInfo.ERROR_UNKNOWN_METHOD, null));
			}
		} catch (exception) {
			errorBroadcaster.dispatch(new MethodInvocationErrorInfo(path, name, MethodInvocationErrorInfo.ERROR_SERVICE_METHOD, exception));
		}
	}
	
	/**
	 * @see ServerServiceProxy#invokeMethodByNameAndArgumentsAndResponseService()
	 */
	public function invokeMethodByNameAndArgumentsAndResponseService(name:String, args:Array, responseService:String):Void {
		var listener:MethodInvocationErrorListener = new MethodInvocationErrorListener();
		var owner:LocalServerServiceProxy = this;
		listener.onError = function(info:MethodInvocationErrorInfo):Void {
			owner.errorBroadcaster.dispatch(new MethodInvocationErrorInfo(owner.path, name, MethodInvocationErrorInfo.ERROR_UNKNOWN, null));
		}
		try {
			if (service[name]) {
				var returnValue = service[name].apply(service, args);
			} else {
				errorBroadcaster.dispatch(new MethodInvocationErrorInfo(path, name, MethodInvocationErrorInfo.ERROR_UNKNOWN_METHOD, null));
			}
			try {
				connection.send(responseService, "onReturn", [returnValue], listener);
			} catch (exception:org.as2lib.data.io.conn.local.core.UnknownConnectionException) {
				errorBroadcaster.dispatch(new MethodInvocationErrorInfo(path, name, MethodInvocationErrorInfo.ERROR_UNKNOWN_SERVICE, exception));
			} catch (exception:org.as2lib.data.io.conn.core.client.MethodInvocationException) {
				errorBroadcaster.dispatch(new MethodInvocationErrorInfo(path, name, MethodInvocationErrorInfo.ERROR_ARGUMENTS_OVERSIZED, exception));
			}
		} catch (exception) {
			try {
				connection.send(responseService, "onError", [exception], listener);
			} catch (exception:org.as2lib.data.io.conn.local.core.UnknownConnectionException) {
				errorBroadcaster.dispatch(new MethodInvocationErrorInfo(path, name, MethodInvocationErrorInfo.ERROR_UNKNOWN_SERVICE, exception));
			} catch (exception:org.as2lib.data.io.conn.core.client.MethodInvocationException) {
				errorBroadcaster.dispatch(new MethodInvocationErrorInfo(path, name, MethodInvocationErrorInfo.ERROR_ARGUMENTS_OVERSIZED, exception));
			}
			errorBroadcaster.dispatch(new MethodInvocationErrorInfo(path, name, MethodInvocationErrorInfo.ERROR_SERVICE_METHOD, exception));
		}
	}
	
	/**
	 * @see ServerServiceProxy#getService()
	 */
	public function getService(Void) {
		return service;
	}
	
	/**
	 * @see ServerServiceProxy#getPath()
	 */
	public function getPath(Void):String {
		return path;
	}
	
	/**
	 * @see ServerServiceProxy#isRunning()
	 */
	public function isRunning(Void):Boolean {
		return running;
	}
	
	/**
	 * @see ServerServiceProxy#addErrorListener()
	 */
	public function addErrorListener(listener:MethodInvocationErrorListener):Void {
		errorBroadcaster.addListener(listener);
	}
	
	/**
	 * @see ServerServiceProxy#removeErrorListener()
	 */
	public function removeErrorListener(listener:MethodInvocationErrorListener):Void {
		errorBroadcaster.removeListener(listener);
	}
	
}