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
import org.as2lib.io.conn.core.client.ClientServiceProxy;
import org.as2lib.io.conn.core.client.AbstractClientServiceProxy;
import org.as2lib.io.conn.core.client.UnknownServiceException;
import org.as2lib.io.conn.core.server.ReservedServiceException;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;
import org.as2lib.io.conn.core.event.MethodInvocationReturnInfo;
import org.as2lib.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.io.conn.core.event.MethodInvocationErrorListener;
import org.as2lib.io.conn.local.core.EnhancedLocalConnection;

/**
 * Proxy handles client request to a certain service and its response.
 * services, which are availiable after server is started.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.io.conn.local.client.LocalClientServiceProxy extends AbstractClientServiceProxy implements ClientServiceProxy {
	
	/** The url of the service. */
	private var url:String;
	
	/** Used EnhancedLocalConnection. */
	private var connection:EnhancedLocalConnection;
	
	/** Stores all currently used response services. */
	private var responseServices:Array;
	
	/**
	 * Constructs a new LocalClientServiceProxy.
	 * 
	 * @param url the url to the service
	 */
	public function LocalClientServiceProxy(url:String) {
		this.url = url;
		connection = new EnhancedLocalConnection();
		responseServices = new Array();
	}
	
	/**
	 * @see ClientServiceProxy#invokeByNameAndArguments()
	 */
	public function invokeByNameAndArguments(name:String, args:Array):MethodInvocationCallback {
		return invokeByNameAndArgumentsAndCallback(name, args, new MethodInvocationCallback());
		/*try {
			connection.send(url, "invokeMethod", [name, args]);
		} catch (exception:org.as2lib.io.conn.local.core.UnknownConnectionException) {
			throw new UnknownServiceException("Service with url [" + url + "] does not exist.", this, arguments).initCause(exception);
		}*/
	}
	
	/**
	 * @see ClientServiceProxy#invokeByNameAndArgumentsAndCallback()
	 */
	public function invokeByNameAndArgumentsAndCallback(name:String, args:Array, callback:MethodInvocationCallback):MethodInvocationCallback {
		var responseUrl:String = generateResponseServiceUrl(url, name);
		
		var responseService:EnhancedLocalConnection = new EnhancedLocalConnection();
		var index:Number = responseServices.push(responseService) - 1;
		var owner:LocalClientServiceProxy = this;
		responseService["onReturn"] = function(returnValue):Void {
			owner.responseServices.splice(index, 1);
			callback.onReturn(new MethodInvocationReturnInfo(returnValue));
			this.close();
		}
		responseService["onError"] = function(exception):Void {
			owner.responseServices.splice(index, 1);
			callback.onError(new MethodInvocationErrorInfo(owner.url, name, MethodInvocationErrorInfo.ERROR_SERVICE_METHOD, exception));
		}
		try {
			responseService.connect(responseUrl);
		} catch (exception:org.as2lib.io.conn.local.core.ReservedConnectionException) {
			throw new ReservedServiceException("Service with url [" + url + "] does already exist.", this, arguments).initCause(exception);
		}
		
		var errorListener:MethodInvocationErrorListener = new MethodInvocationErrorListener();
		errorListener.onError = function(info:MethodInvocationErrorInfo) {
			callback.onError(info);
		}
		
		try {
			connection.send(url, "invokeMethod", [name, args, responseUrl], errorListener);
		} catch (exception:org.as2lib.io.conn.local.core.UnknownConnectionException) {
			throw new UnknownServiceException("Service with url [" + url + "] does not exist.", this, arguments).initCause(exception);
		}
		
		return callback;
	}
	
	/**
	 * Enables us to use the proxy as follows:
	 * <code>myProxy.myMethod("myArg1", myCallback);</code>
	 * 
	 * @param methodName the name of the method to invoke on the remote service
	 * @return the function to execute as the actual method passing the actual arguments
	 */
	private function __resolve(methodName:String):Function {
		var owner:ClientServiceProxy = this;
		return (function():Void {
			if (arguments[arguments.length] instanceof MethodInvocationCallback) {
				owner.invokeByNameAndArgumentsAndCallback(methodName, arguments, MethodInvocationCallback(arguments.pop()));
			} else {
				owner.invokeByNameAndArguments(methodName, arguments);
			}
		});
	}

}