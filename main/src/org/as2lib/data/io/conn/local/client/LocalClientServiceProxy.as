﻿/*
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
import org.as2lib.data.io.conn.core.client.ClientServiceProxy;
import org.as2lib.data.io.conn.core.client.AbstractClientServiceProxy;
import org.as2lib.data.io.conn.core.client.UnknownServiceException;
import org.as2lib.data.io.conn.core.server.ReservedServiceException;
import org.as2lib.data.io.conn.core.event.MethodInvocationCallback;
import org.as2lib.data.io.conn.core.event.MethodInvocationReturnInfo;
import org.as2lib.data.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.data.io.conn.core.event.MethodInvocationErrorListener;
import org.as2lib.data.io.conn.local.core.LocalConnectionTemplate;

/**
 * Proxy handles client request to a certain service and its response.
 * services, which are availiable after server is started.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.data.io.conn.local.client.LocalClientServiceProxy extends AbstractClientServiceProxy implements ClientServiceProxy {
	
	/** The url of the service. */
	private var url:String;
	
	/** Used LocalConnectionTemplate. */
	private var connection:LocalConnectionTemplate;
	
	/** Stores all currently used response services. */
	private var responseServices:Array;
	
	/**
	 * Constructs a new LocalClientServiceProxy.
	 * 
	 * @param url the url to the service
	 */
	public function LocalClientServiceProxy(url:String) {
		this.url = url;
		connection = new LocalConnectionTemplate();
		responseServices = new Array();
	}
	
	/**
	 * @see ClientServiceProxy#invoke()
	 */
	public function invoke():Void {
		var o:Overload = new Overload(this);
		o.addHandler([String], invokeByName);
		o.addHandler([String, Array], invokeByNameAndArguments);
		o.addHandler([String, MethodInvocationCallback], invokeByNameAndCallback);
		o.addHandler([String, Array, MethodInvocationCallback], invokeByNameAndArgumentsAndCallback);
		o.forward(arguments);
	}
	
	/**
	 * @see ClientServiceProxy#invokeByName()
	 */
	public function invokeByName(name:String):Void {
		invokeByNameAndArguments(name, []);
	}
	
	/**
	 * @see ClientServiceProxy#invokeByNameAndArguments()
	 */
	public function invokeByNameAndArguments(name:String, args:Array):Void {
		try {
			connection.send(url, "invokeMethod", [name, args]);
		} catch (exception:org.as2lib.data.io.conn.local.core.UnknownConnectionException) {
			throw new UnknownServiceException("Service with url [" + url + "] does not exist.", this, arguments).initCause(exception);
		}
	}
	
	/**
	 * @see ClientServiceProxy#invokeByNameAndCallback()
	 */
	public function invokeByNameAndCallback(name:String, callback:MethodInvocationCallback):Void {
		invokeByNameAndArgumentsAndCallback(name, [], callback);
	}
	
	/**
	 * @see ClientServiceProxy#invokeByNameAndArgumentsAndCallback()
	 */
	public function invokeByNameAndArgumentsAndCallback(name:String, args:Array, callback:MethodInvocationCallback):Void {
		var responseUrl:String = generateResponseServiceUrl(url, name);
		
		var responseService:LocalConnectionTemplate = new LocalConnectionTemplate();
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
		} catch (exception:org.as2lib.data.io.conn.local.core.ReservedConnectionException) {
			throw new ReservedServiceException("Service with url [" + url + "] does already exist.", this, arguments).initCause(exception);
		}
		
		var errorListener:MethodInvocationErrorListener = new MethodInvocationErrorListener();
		errorListener.onError = function(info:MethodInvocationErrorInfo) {
			callback.onError(info);
		}
		
		try {
			connection.send(url, "invokeMethod", [name, args, responseUrl], errorListener);
		} catch (exception:org.as2lib.data.io.conn.local.core.UnknownConnectionException) {
			throw new UnknownServiceException("Service with url [" + url + "] does not exist.", this, arguments).initCause(exception);
		}
	}

}