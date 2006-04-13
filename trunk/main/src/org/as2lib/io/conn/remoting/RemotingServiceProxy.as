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

import mx.remoting.Connection;
import mx.remoting.PendingCall;
import mx.remoting.Service;
import mx.rpc.Fault;
import mx.rpc.FaultEvent;
import mx.rpc.RelayResponder;
import mx.rpc.ResultEvent;
import mx.services.Log;

import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.io.conn.core.client.AbstractClientServiceProxy;
import org.as2lib.io.conn.core.client.ClientServiceProxy;
import org.as2lib.io.conn.core.event.MethodInvocationCallback;
import org.as2lib.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.io.conn.core.event.MethodInvocationReturnInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.io.conn.remoting.RemotingServiceProxy extends AbstractClientServiceProxy implements ClientServiceProxy {
	
	private var service:Service;
	private var gatewayUri:String;
	private var serviceName:String;
	
	public function RemotingServiceProxy(gatewayUri:String, serviceName:String, logger:Log, connection:Connection) {
		this.gatewayUri = gatewayUri;
		this.serviceName = serviceName;
		service = new Service(gatewayUri, logger, serviceName, connection);
	}
	
	public function getGatewayUri(Void):String {
		return gatewayUri;
	}
	
	public function getServiceName(Void):String {
		return serviceName;
	}
	
	public function invokeByNameAndArgumentsAndCallback(methodName:String, args:Array, callback:MethodInvocationCallback):MethodInvocationCallback {
		if (methodName == null) {
			throw new IllegalArgumentException("Argument 'methodName' [" + methodName + "] must not be 'null' nor 'undefined'", this, arguments);
		}
		if (args == null) {
			args = new Array();
		}
		if (callback == null) {
			callback = getBlankMethodInvocationCallback();
		}
		var pc:PendingCall = service[methodName].apply(service, args);
		var responder:Object = new Object();
		responder.onResult = function(resultEvent:ResultEvent):Void {
			var info:MethodInvocationReturnInfo = new MethodInvocationReturnInfo(this, methodName, args, resultEvent.result);
			callback.onReturn(info);
		};
		responder.onFault = function(faultEvent:FaultEvent):Void {
			var info:MethodInvocationErrorInfo = new MethodInvocationErrorInfo(this, methodName, args, faultEvent.fault.faultcode, faultEvent.fault.faultstring);
			// TODO: Add detail, description and type information from Fault instance
			// detail: String; Provides access to the detail information provided by the remote service
			// description: String; Provides access to the description of the error provided by the remote service
			// type: String; Provides access to the type information provided by the remote service.
			callback.onError(info);
		};
		pc.responder = new RelayResponder(responder, "onResult", "onFault");
		return callback;
	}
	
}