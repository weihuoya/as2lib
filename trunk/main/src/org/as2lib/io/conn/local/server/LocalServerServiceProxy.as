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
 * LocalServerServiceProxy handles client requests to a certain service
 * and its response.
 *
 * <p>This client requests normally come from a client service proxy
 * because this class is designed to interact with this type of client.
 *
 * <p>You can setup your service proxy as follows to await client requests:
 * <code>
 * var service:LocalServerServiceProxy = new LocalServerServiceProxy("myService", new MyService());
 * service.run();
 * </code>
 *
 * <p>A client may then call the invoke method on this service proxy.
 * <code>
 * var client = new LocalClientServiceProxy("local.as2lib.org/myService");
 * var callback:MethodInvocationCallback = client.myMethod("firstArgument", "secondArgument");
 * </code>
 *
 * <p>You may choose to combine multiple services in one server for
 * easier usage.
 * <code>
 * var server:LocalServer = new LocalServer("local.as2lib.org");
 * server.addService(new LocalServerServiceProxy("myServiceOne", new MyServiceOne()));
 * server.addService(new LocalServerServiceProxy("myServiceTwo", new MyServiceTwo()));
 * server.run();
 * </code>
 *
 * <p>A client would then need to prefix the service's name with the
 * host of the server.
 * <code>
 * var client = new LocalClientServiceProxy("local.as2lib.org/myService");
 * var callback:MethodInvocationCallback = client.myMethod("firstArgument", "secondArgument");
 * </code>
 *
 * @author Simon Wacker
 * @author Christoph Atteneder
 */
class org.as2lib.io.conn.local.server.LocalServerServiceProxy extends AbstractServerServiceProxy implements ServerServiceProxy {
	
	/** Wrapped service object. */
	private var service;
	
	/** Service path. */
	private var path:String;
	
	/** Used to set up the service. */
	private var connection:EnhancedLocalConnection;
	
	/** Stores set error listener. */
	private var errorBroadcaster:EventBroadcaster;
	
	/** Service's status. */
	private var running:Boolean;
	
	/**
	 * Constructs a new LocalServerServiceProxy instance.
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
	 * Runs the service proxy on the passed-in host.
	 *
	 * <p>The service proxy will be restarted if it is already running. That
	 * means it first stops itself and starts it again.
	 *
	 * <p>Only the path of the service proxy gets used to connect if the host
	 * is null, undefined or a blank string.
	 *
	 * @param host the host to run the service on
	 * @throws ReservedServiceException if a service on the passed-in host with the service's path is already in use
	 * @see ServerServiceProxy#run(String):Void
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
	 * Stops the service.
	 *
	 * @see ServerServiceProxy#stop(Void):Void
	 */
	public function stop(Void):Void {
		getConnection().close();
		running = false;
	}
	
	/**
	 * Handles an incoming 'remote' method invocation to the service.
	 *
	 * <p>The method corresponding to the passed-in method name gets
	 * executed on the service.
	 *
	 * <p>The error listeners will be informed of a failure if:
	 * <ul>
	 *   <li>A method with the passed-in name does not exist on the service.</li>
	 *   <li>The service method threw an exception.</li>
	 * </ul>
	 *
	 * @param methodName the name of the method to invoke on the service
	 * @param args the arguments to be used as parameters when invoking the method
	 * @see ServerServiceProxy#invokeMethodByNameAndArguments(String, Array):Void
	 */
	public function invokeMethodByNameAndArguments(methodName:String, args:Array):Void {
		try {
			if (service[methodName]) {
				service[methodName].apply(service, args);
			} else {
				getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(path, methodName, args, MethodInvocationErrorInfo.UNKNOWN_METHOD_ERROR, null));
			}
		} catch (exception) {
			getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(path, methodName, args, MethodInvocationErrorInfo.METHOD_EXCEPTION_ERROR, exception));
		}
	}
	
	/**
	 * Handles incoming 'remote' method invocations to the service and
	 * responses through the response service url.
	 *
	 * <p>The method corresponding to the passed-in method name gets
	 * executed on the service and the response of this execution gets
	 * passed though the response service's url to the client.
	 *
	 * <p>If the response service url is null or an empty string the
	 * #invokeMethodByNameAndArguments(String, Array):Void method gets
	 * invoked instead.
	 *
	 * <p>The response service is supposed to be of type MethodInvocationCallback.
	 * And thus defines the two methods onReturn(MethodInvocationReturInfo):Void
	 * and onError(MethodInvocationErrorInfo):Void.
	 *
	 * <p>The onReturn(..) method gets invoked on the response service if
	 * the method executed successfully.
	 *
	 * <p>The onError(..) method gets invoked on the response service if:
	 * <ul>
	 *   <li>The method threw an exception.</li>
	 *   <li>The method does not exist on the service.</li>
	 * </ul>
	 *
	 * <p>The error listeners will be informed of a failure if:
	 * <ul>
	 *   <li>A method with the passed-in name does not exist on the service.</li>
	 *   <li>The service method threw an exception.</li>
	 *   <li>The response server with the given url does not exist.</li>
	 *   <li>The return value is to big to send over a local connection.</li>
	 *   <li>An unknown failure occured when trying to send the response.</li>
	 * </ul>
	 *
	 * @param methodName the name of the method to invoke on the service
	 * @param args the arguments to be used as parameters when invoking the method
	 * @param responseServiceUrl the url to the service that handles the response
	 * @see ServerServiceProxy#invokeMethodByNameAndArgumentsAndResponseService(String, Array, String):Void
	 */
	public function invokeMethodByNameAndArgumentsAndResponseService(methodName:String, args:Array, responseServiceUrl:String):Void {
		if (!responseServiceUrl) {
			invokeMethodByNameAndArguments(methodName, args);
			return;
		}
		var listener:MethodInvocationErrorListener = new MethodInvocationErrorListener();
		var owner:LocalServerServiceProxy = this;
		listener.onError = function(info:MethodInvocationErrorInfo):Void {
			owner.getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(owner.getPath(), methodName, args, MethodInvocationErrorInfo.UNKNOWN_ERROR, null));
		}
		try {
			if (service[methodName]) {
				var returnValue = service[methodName].apply(service, args);
				sendResponse(methodName, args, responseServiceUrl, "onReturn", [new MethodInvocationReturnInfo(getPath(), methodName, args, returnValue)], listener);
			} else {
				sendResponse(methodName, args, responseServiceUrl, "onError", [new MethodInvocationErrorInfo(getPath(), methodName, args, MethodInvocationErrorInfo.UNKNOWN_METHOD_ERROR, null)], listener);
				getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(getPath(), methodName, args, MethodInvocationErrorInfo.UNKNOWN_METHOD_ERROR, null));
			}
		} catch (serviceMethodException) {
			sendResponse(methodName, args, responseServiceUrl, "onError", [new MethodInvocationErrorInfo(path, methodName, args, MethodInvocationErrorInfo.METHOD_EXCEPTION_ERROR, serviceMethodException)], listener)
			getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(getPath(), methodName, args, MethodInvocationErrorInfo.METHOD_EXCEPTION_ERROR, serviceMethodException));
		}
	}
	
	/**
	 * Sends a response to the client.
	 */
	private function sendResponse(methodName:String, methodArguments:Array, responseServiceUrl:String, responseMethod:String, responseArguments:Array, responseListener:MethodInvocationErrorListener):Void {
		try {
			getConnection().send(responseServiceUrl, responseMethod, responseArguments, responseListener);
		} catch (uce:org.as2lib.io.conn.local.core.UnknownConnectionException) {
			getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(getPath(), methodName, methodArguments, MethodInvocationErrorInfo.UNKNOWN_SERVICE_ERROR, uce));
		} catch (mie:org.as2lib.io.conn.core.client.MethodInvocationException) {
			getErrorBroadcaster().dispatch(new MethodInvocationErrorInfo(getPath(), methodName, methodArguments, MethodInvocationErrorInfo.OVERSIZED_ARGUMENTS_ERROR, mie));
		}
	}
	
	/**
	 * Returns the wrapped service.
	 *
	 * @return the wrapped service
	 * @see ServerServiceProxy#getService(Void)
	 */
	public function getService(Void) {
		return service;
	}
	
	/**
	 * Returns the path of this service.
	 *
	 * @see ServerServiceProxy#getPath(Void):String
	 */
	public function getPath(Void):String {
		return path;
	}
	
	/**
	 * Returns whether this service is running or not.
	 *
	 * @return true if this service runs else false
	 * @see ServerServiceProxy#isRunning(Void):Boolean
	 */
	public function isRunning(Void):Boolean {
		return running;
	}
	
	/**
	 * Adds an error listener.
	 * 
	 * <p>Error listeners get notified when a client tried to invoke a method
	 * on the service and something went wrong.
	 *
	 * @param listener the new error listener to add
	 * @see ServerServiceProxy#addErrorListener(MethodInvocationErrorListener):Void
	 */
	public function addErrorListener(listener:MethodInvocationErrorListener):Void {
		getErrorBroadcaster().addListener(listener);
	}
	
	/**
	 * Removes an error listener.
	 *
	 * <p>Error listeners get notified when a client tried to invoke a method
	 * on the service and something went wrong.
	 *
	 * @param listener the error listener to remove
	 * @see ServerServiceProxy#removeErrorListener(MethodInvocationErrorListener):Void
	 */
	public function removeErrorListener(listener:MethodInvocationErrorListener):Void {
		getErrorBroadcaster().removeListener(listener);
	}
	
}