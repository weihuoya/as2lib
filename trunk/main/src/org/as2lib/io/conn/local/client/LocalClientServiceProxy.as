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
import org.as2lib.env.except.IllegalArgumentException;
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
 * LocalClientServiceProxy handles client requests to a certain service
 * and its response.
 * 
 * <p>You can use the proxy as follows:
 * <code>
 * var client:LocalClientServiceProxy = new LocalClientServiceProxy("local.as2lib.org/myService");
 * var callback:MethodInvocationCallback = client.invoke("myMethod", ["firstArgument", "secondArgument"]);
 * callback.onReturn = function(returnInfo:MethodInvocationReturnInfo):Void {
 *   trace("myMethod - return value: " + returnInfo.getReturnValue());
 * }
 * callback.onError = function(errorInfo:MethodInvocationErrorInfo):Void {
 *   trace("myMethod - error: " + errorInfo.getException());
 * }
 * </code>
 *
 * <p>It is also possible to call the method directly on the proxy. But you can't
 * type the proxy then.
 * <code>
 * var client = new LocalClientServiceProxy("local.as2lib.org/myService");
 * var callback:MethodInvocationCallback = client.myMethod("firstArgument", "secondArgument");
 * </code>
 *
 * <p>The neatest way is to use LocalClientServiceProxyFactory to get a proxy
 * for a service interface or class, which enables compiler checks.
 * For more information on this refer to the LocalClientServiceProxyFactory class.
 *
 * <p>If the return value is not of type Number, Boolean, String or
 * Array that get converted directly into the appropriate type you must
 * do the following to receive a value of correct type. Otherwise the
 * return value will be an instance of type Object that gets populated
 * with the instance variables of the sent object.
 * <code>Object.registerClass("MyClass", MyClass);</code>
 *
 * <p>The received object will now be of correct type. But you still
 * have to be aware of some facts.
 * Flash creates a new object in the background and sets the instance
 * variables of the sent instance to the new object. It then registers
 * this object to the appropriate class (if registered previously) and
 * applies the constructor of that class to the new object passing no
 * arguments.
 * That means if the constructor sets instance variables it overwrites
 * the once set previously by undefined.
 *
 * @author Simon Wacker
 * @author Christoph Atteneder
 * @see org.as2lib.io.conn.local.client.LocalClientServiceProxyFactory
 */
class org.as2lib.io.conn.local.client.LocalClientServiceProxy extends AbstractClientServiceProxy implements ClientServiceProxy {
	
	/** The url of the service. */
	private var url:String;
	
	/** Used EnhancedLocalConnection. */
	private var connection:EnhancedLocalConnection;
	
	/** Stores all currently used response services. */
	private var responseServices:Array;
	
	/**
	 * Constructs a new LocalClientServiceProxy instance.
	 * 
	 * @param url the url to the service
	 * @throws IllegalArgumentException if the url is null, undefined or an empty string
	 */
	public function LocalClientServiceProxy(url:String) {
		if (!url) throw new IllegalArgumentException("Url must not be null, undefined or an empty string.", this, arguments);
		this.url = url;
		connection = new EnhancedLocalConnection();
		responseServices = new Array();
	}
	
	/**
	 * Returns the url of the service this proxy connects to.
	 *
	 * <p>The url is never null, undefined or an empty string.
	 *
	 * @return the url of the service to connect to
	 */
	public function getUrl(Void):String {
		return url;
	}
	
	/**
	 * Invokes the method with the passed-in arguments on the 'remote'
	 * service.
	 *
	 * <p>The response of the method invocation gets delegated to the
	 * appropriate method on the returned callback. That is either the
	 * onReturn-method when no error occured. Or the onError-method in
	 * case something went wrong.
	 *
	 * @param methodName the name of the method to invoke on the 'remote' service
	 * @param args the arguments that get passed to the method as parameters
	 * @return the callback that handles the response
	 * @throws IllegalArgumentException if the passed-in method name is null or an empty string
	 * @see ClientServiceProxy#invokeByNameAndArguments(String, Array):MethodInvocationCallback
	 */
	public function invokeByNameAndArguments(methodName:String, args:Array):MethodInvocationCallback {
		return invokeByNameAndArgumentsAndCallback(methodName, args, null);
	}
	
	/**
	 * Invokes the method with the passed-in arguments on the 'remote'
	 * service.
	 * 
	 * <p>The response of the method invocation gets delegated to the
	 * appropriate method on the passed-in callback. That is either the
	 * onReturn-method when no error occured. Or the onError-method in
	 * case something went wrong.
	 *
	 * <p>If the passed-in callback is null a new MethodInvocationCallback
	 * instance will be created and returned. It is possible to still set 
	 * the callback methods there, after invoking this method.
	 *
	 * @param methodName the name of the method to invoke on the 'remote' service
	 * @param args the arguments that get passed to the method as parameters
	 * @param callback the callback that handles the response
	 * @return either the passed-in callback or a new callback if null
	 * @throws IllegalArgumentException if the passed-in method name is null or an empty string
	 * @see ClientServiceProxy#invokeByNameAndArgumentsAndCallback(String, Array, MethodInvocationCallback):MethodInvocationCallback
	 */
	public function invokeByNameAndArgumentsAndCallback(methodName:String, args:Array, callback:MethodInvocationCallback):MethodInvocationCallback {
		if (!methodName) throw new IllegalArgumentException("Method name must not be null, undefined or an empty string.", this, arguments);
		if (!args) args = new Array();
		if (!callback) callback = getBlankMethodInvocationCallback();
		
		var responseUrl:String = generateResponseServiceUrl(url, methodName);
		
		var responseService:EnhancedLocalConnection = new EnhancedLocalConnection();
		var index:Number = responseServices.push(responseService) - 1;
		var owner:LocalClientServiceProxy = this;
		responseService["onReturn"] = function(returnValue):Void {
			owner.responseServices.splice(index, 1);
			callback.onReturn(new MethodInvocationReturnInfo(owner.url, methodName, args, returnValue));
			this.close();
		}
		responseService["onError"] = function(errorCode:Number, exception):Void {
			owner.responseServices.splice(index, 1);
			callback.onError(new MethodInvocationErrorInfo(owner.url, methodName, args, errorCode, exception));
			this.close();
		}
		try {
			responseService.connect(responseUrl);
		} catch (exception:org.as2lib.io.conn.local.core.ReservedConnectionException) {
			throw new ReservedServiceException("Response service with url [" + responseUrl + "] does already exist.", this, arguments).initCause(exception);
		}
		
		var errorListener:MethodInvocationErrorListener = getBlankMethodInvocationErrorListener();
		errorListener.onError = function(info:MethodInvocationErrorInfo) {
			callback.onError(info);
		}
		
		try {
			connection.send(url, "invokeMethod", [methodName, args, responseUrl], errorListener);
		} catch (exception:org.as2lib.io.conn.local.core.UnknownConnectionException) {
			throw new UnknownServiceException("Service with url [" + url + "] does not exist.", this, arguments).initCause(exception);
		}
		
		return callback;
	}
	
	/**
	 * Returns a blank method invocation error listener. That is
	 * a error listern with no initialized methods.
	 *
	 * @return a blank method invocation error listener
	 */
	private function getBlankMethodInvocationErrorListener(Void):MethodInvocationErrorListener {
		var result = new Object();
		result.__proto__ = MethodInvocationErrorListener["prototype"];
		return result;
	}
	
	/**
	 * Returns a blank method invocation callback. That is a
	 * callback with no initialized methods.
	 *
	 * @return a blank method invocation callback
	 */
	private function getBlankMethodInvocationCallback(Void):MethodInvocationCallback {
		var result = new Object();
		result.__proto__ = MethodInvocationCallback["prototype"];
		return result;
	}
	
	/**
	 * Enables you to invoke the method to be invoked on the 'remote' service
	 * directly on this proxy.
	 *
	 * <p>The usage is mostly the same.
	 * <code>myProxy.myMethod("myArg1");</code>
	 * <code>myProxy.myMethod("myArg1", myCallback);</code>
	 * <code>var callback:MethodInvocationCallback = myProxy.myMethod("myArg1");</code>
	 * 
	 * @param methodName the name of the method to invoke on the 'remote' service
	 * @return the function to execute as the actual method passing the actual arguments
	 */
	private function __resolve(methodName:String):Function {
		var owner:ClientServiceProxy = this;
		return (function():MethodInvocationCallback {
			if (arguments[arguments.length] instanceof MethodInvocationCallback) {
				return owner.invokeByNameAndArgumentsAndCallback(methodName, arguments, MethodInvocationCallback(arguments.pop()));
			} else {
				return owner.invokeByNameAndArgumentsAndCallback(methodName, arguments, null);
			}
		});
	}

}