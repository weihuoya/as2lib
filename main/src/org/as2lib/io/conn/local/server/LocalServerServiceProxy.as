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

import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SpeedEventBroadcaster;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.io.conn.core.server.AbstractServerServiceProxy;
import org.as2lib.io.conn.core.server.ServerServiceProxy;
import org.as2lib.io.conn.core.server.ReservedServiceException;
import org.as2lib.io.conn.core.event.MethodInvocationErrorListener;
import org.as2lib.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.io.conn.core.event.MethodInvocationReturnInfo;
import org.as2lib.io.conn.local.core.EnhancedLocalConnection;

/**
 * Proxy handles client request to a certain service and its response.
 * services, which are availiable after server is started.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.io.conn.local.server.LocalServerServiceProxy extends AbstractServerServiceProxy implements ServerServiceProxy {
	
	/** Wrapped service object. */
	private var service;
	
	/** Service path. */
	private var path:String;
	
	/** Used to set up the server. */
	private var connection:EnhancedLocalConnection;
	
	/** Stores added MethodInvocationErrorListeners. */
	private var errorBroadcaster:EventBroadcaster;
	
	/** Service status. */
	private var running:Boolean;
	
	/**
	 * Constructs a new LocalServerServiceProxy.
	 *
	 * @param path the path of the service
	 * @param service object which provides the service operations
	 * @throws IllegalArgumentException if the path is null, undefined or a blank string
	 *                                  if the service is null or undefined
	 */
	public function LocalServerServiceProxy(path:String, service) {
		if (!path || !service) throw new IllegalArgumentException("Neither the path [" + path + "] nor the service [" + service + "] are allowed to be null, undefined or a blank string.", this, arguments);
		this.path = path;
		this.service = service;
		running = false;
	}
	
	/**
	 * Returns the currently used connection.
	 *
	 * <p>This is either the connection set via #setConnection(EnhancedLocalConnection):Void
	 * of a default EnhancedLocalConnection instance.
	 *
	 * @return the currently used connection
	 */
	public function getConnection(Void):EnhancedLocalConnection {
		if (!connection) connection = new EnhancedLocalConnection(this);
		return connection;
	}
	
	/**
	 * Sets a new connection.
	 *
	 * <p>The target of the connection, that means the receiver of all remote
	 * calls must be this instance. If it is not nothing will work properly.
	 *
	 * <p>If you set a connection of value null or undefined #getConnection(Void):EnhancedLocalConnection
	 * will return the default connection.
	 *
	 * @param connection the new connection to use
	 */
	public function setConnection(connection:EnhancedLocalConnection):Void {
		this.connection = connection;
	}
	
	/**
	 * Returns the currently used error broadcaster.
	 *
	 * <p>This is either the one set via #setErrorBroadcaster(EventBroadcaster):Void
	 * or the default SpeedEventBroadcaster instance.
	 *
	 * @return the currently used error broadcaster
	 */
	public function getErrorBroadcaster(Void):EventBroadcaster {
		if (!errorBroadcaster) errorBroadcaster = new SpeedEventBroadcaster();
		return errorBroadcaster;
	}
	
	/**
	 * Sets a new error broadcaster.
	 *
	 * <p>If you set an error broadcaster of value null or undefined
	 * #getErrorBroadcaster(Void):EventBroadcaster will return the default
	 * broadcaster.
	 *
	 * @param errorBroadcaster the new error broadcaster
	 */
	public function setErrorBroadcaster(errorBroadcaster:EventBroadcaster):Void {
		this.errorBroadcaster = errorBroadcaster;
	}
	
	/**
	 * <p>The service proxy will be restarted if it is already running. That
	 * means it first stops itself and starts it again.
	 *
	 * <p>Only the path of the service proxy gets used to connect if the host
	 * is null, undefined or a blank string.
	 *
	 * @throws ReservedServiceException if a service on the passed-in host with the service's path is already in use
	 * @see ServerServiceProxy#run()
	 */
	public function run(host:String):Void {
		if (isRunning()) this.stop();
		try {
			getConnection().connect(generateServiceUrl(host, path));
			running = true;
		} catch(exception:org.as2lib.io.conn.local.core.ReservedConnectionException) {
			throw new ReservedServiceException("Service with path [" + path + "] on host [" + host + "] is already in use.", this, arguments).initCause(exception);
		}
	}
	
	/**
	 * @see ServerServiceProxy#stop()
	 */
	public function stop(Void):Void {
		getConnection().close();
		running = false;
	}
	
	/**
	 * @see ServerServiceProxy#invokeMethodByNameAndArguments()
	 */
	public function invokeMethodByNameAndArguments(name:String, args:Array):Void {
		try {
			if (service[name]) {
				service[name].apply(service, args);
			} else {
				getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(path, name, MethodInvocationErrorInfo.ERROR_UNKNOWN_METHOD, null));
			}
		} catch (exception) {
			getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(path, name, MethodInvocationErrorInfo.ERROR_SERVICE_METHOD, exception));
		}
	}
	
	/**
	 * @see ServerServiceProxy#invokeMethodByNameAndArgumentsAndResponseService()
	 */
	public function invokeMethodByNameAndArgumentsAndResponseService(name:String, args:Array, responseService:String):Void {
		if (!responseService) {
			invokeMethodByNameAndArguments(name, args);
			return;
		}
		var listener:MethodInvocationErrorListener = new MethodInvocationErrorListener();
		var owner:LocalServerServiceProxy = this;
		listener.onError = function(info:MethodInvocationErrorInfo):Void {
			owner.getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(owner.getPath(), name, MethodInvocationErrorInfo.ERROR_UNKNOWN, null));
		}
		try {
			if (service[name]) {
				var returnValue = service[name].apply(service, args);
				sendResponse(name, responseService, "onReturn", [new MethodInvocationReturnInfo(returnValue)], listener);
			} else {
				sendResponse(name, responseService, "onError", [new MethodInvocationErrorInfo(getPath(), name, MethodInvocationErrorInfo.ERROR_UNKNOWN_METHOD, null)], listener);
				getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(getPath(), name, MethodInvocationErrorInfo.ERROR_UNKNOWN_METHOD, null));
			}
		} catch (serviceMethodException) {
			sendResponse(name, responseService, "onError", [new MethodInvocationErrorInfo(path, name, MethodInvocationErrorInfo.ERROR_SERVICE_METHOD, serviceMethodException)], listener)
			getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(getPath(), name, MethodInvocationErrorInfo.ERROR_SERVICE_METHOD, serviceMethodException));
		}
	}
	
	/**
	 * Sends a response to the client.
	 */
	private function sendResponse(methodName:String, responseService:String, responseMethod:String, responseArguments:Array, responseListener:MethodInvocationErrorListener):Void {
		try {
			getConnection().send(responseService, responseMethod, responseArguments, responseListener);
		} catch (uce:org.as2lib.io.conn.local.core.UnknownConnectionException) {
			getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(getPath(), methodName, MethodInvocationErrorInfo.ERROR_UNKNOWN_SERVICE, uce));
		} catch (mie:org.as2lib.io.conn.core.client.MethodInvocationException) {
			getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(getPath(), methodName, MethodInvocationErrorInfo.ERROR_ARGUMENTS_OVERSIZED, mie));
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
		getErrorBroadcaster().addListener(listener);
	}
	
	/**
	 * @see ServerServiceProxy#removeErrorListener()
	 */
	public function removeErrorListener(listener:MethodInvocationErrorListener):Void {
		getErrorBroadcaster().removeListener(listener);
	}
	
}