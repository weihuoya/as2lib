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
import org.as2lib.env.overload.Overload;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SpeedEventBroadcaster;

import org.as2lib.data.io.conn.core.event.MethodInvocationErrorListener;
import org.as2lib.data.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.data.io.conn.core.client.MethodInvocationException;
import org.as2lib.data.io.conn.local.core.ConnectionAlreadyOpenException;
import org.as2lib.data.io.conn.local.core.ConnectionNotOpenException;
import org.as2lib.data.io.conn.local.core.ReservedConnectionException;
import org.as2lib.data.io.conn.local.core.UnknownConnectionException;

/**
 * Provides extended LocalConnection functionalities.
 * It provides centralized ExceptionHandling and establishes LocalConnections.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */
class org.as2lib.data.io.conn.local.core.LocalConnectionTemplate extends BasicClass {
	
	/** object for handling connection problems. In most cases set to ExtendedLocalConnection instance.*/
	private var target:Object;
	
	/** Indicates whether the connection is open (true) or closed (false). */
	private var connected:Boolean;
	
	/** Stores added MethodInvocationErrorListener. */
	private var errorBroadcaster:EventBroadcaster;
	
	/** Stores clients waiting for status reports. */
	private var clientArray:Array;
	
	/**
	 * Checks if a connection with the passed identifier exists.
	 * 
	 * @param connectionName the name of the connection
	 * @return true if connection exists
	 */
	public static function connectionExists(connectionName:String):Boolean {
		var lc:LocalConnection = new LocalConnection();
		var result:Boolean = !lc.connect(connectionName);
		lc.close();
		return result;
	}
	
	/**
	 * @overload #LocalConnectionTemplateByVoid
	 * @overload #LocalConnectionTemplateByTarget
	 */
	public function LocalConnectionTemplate() {
		var o:Overload = new Overload(this);
		o.addHandler([], LocalConnectionTemplateByVoid);
		o.addHandler([Object], LocalConnectionTemplateByTarget);
		o.forward(arguments);
	}
	
	/**
	 * Constructs a new LocalConnectionTemplateByVoid.
	 */
	private function LocalConnectionTemplateByVoid(Void):Void {
		LocalConnectionTemplateByTarget(this);
	}
	
	/**
	 * Constructs a new LocalConnectionTemplateByTarget with target.
	 * 
	 * @param target to be used as server when creating a new connection
	 */
	private function LocalConnectionTemplateByTarget(target):Void {
		this.target = target;
		connected = false;
		errorBroadcaster = new SpeedEventBroadcaster();
		clientArray = new Array();
	}
	
	/**
	 * @see LocalConnectionTemplate#connect()
	 */
	public function connect(connectionName:String):Void {
		if (connected) throw new ConnectionAlreadyOpenException("The connection is already open.", this, arguments);
		if (!LocalConnection.prototype.connect.apply(target, [connectionName]))
			throw new ReservedConnectionException("Connection with name [" + connectionName + "] is already in use.", this, arguments);
		connected = true;
	}
	
	/**
	 * @see LocalConnectionTemplate#close()
	 */
	public function close(Void):Void {
		if (!connected) throw new ConnectionNotOpenException("There is no open connection to close.", this, arguments);
		LocalConnection.prototype.close.apply(target);
		connected = false;
	}
	
	/**
	 * @see LocalConnectionTemplate#send()
	 */
	public function send():Void {
		var o:Overload = new Overload(this);
		o.addHandler([String, String], sendByConnectionAndMethod);
		o.addHandler([String, String, Array], sendByConnectionAndMethodAndArguments);
		o.addHandler([String, String, MethodInvocationErrorListener], sendByConnectionAndMethodAndListener);
		o.addHandler([String, String, Array, MethodInvocationErrorListener], sendByConnectionAndMethodAndArgumentsAndListener);
		o.forward(arguments);
	}
	
	/**
	 * @see LocalConnectionTemplate#sendByConnectionAndMethod()
	 */
	public function sendByConnectionAndMethod(connectionName:String, method:String):Void {
		sendByConnectionAndMethodAndArguments(connectionName, method, []);
	}
	
	/**
	 * @see LocalConnectionTemplate#sendByConnectionAndMethodAndArguments()
	 */
	public function sendByConnectionAndMethodAndArguments(connectionName:String, method:String, args:Array):Void {
		if (!connectionExists(connectionName)) throw new UnknownConnectionException("Connection with name [" + connectionName + "] does not exist.", this, arguments);
		var client:LocalConnection = new LocalConnection();
		var owner:LocalConnectionTemplate = this;
		var index:Number = clientArray.push(client) - 1;
		client.onStatus = function(info) {
			owner.clientArray.splice(index, 1);
			if (info.level == "error") {
				owner.dispatchError(new MethodInvocationErrorInfo(connectionName, method, MethodInvocationErrorInfo.ERROR_UNKNOWN));
			}
		}
		if (!LocalConnection.prototype.send.apply(client, [connectionName, method].concat(args)))
			throw new MethodInvocationException("Passed arguments [" + args + "] are out of size.", this, arguments);
	}
	
	/**
	 * @see LocalConnectionTemplate#sendByConnectionAndMethodAndListener()
	 */
	public function sendByConnectionAndMethodAndListener(connectionName:String, method:String, listener:MethodInvocationErrorListener):Void {
		sendByConnectionAndMethodAndArgumentsAndListener(connectionName, method, [], listener);
	}
	
	/**
	 * @see LocalConnectionTemplate#sendByConnectionAndMethodAndArgumentsAndListener()
	 */
	public function sendByConnectionAndMethodAndArgumentsAndListener(connectionName:String, method:String, args:Array, listener:MethodInvocationErrorListener):Void {
		if (!connectionExists(connectionName)) throw new UnknownConnectionException("Connection with name [" + connectionName + "] does not exist.", this, arguments);
		var client:LocalConnection = new LocalConnection();
		var owner:LocalConnectionTemplate = this;
		var index:Number = clientArray.push(client) - 1;
		client.onStatus = function(info) {
			owner.clientArray.splice(index, 1);
			if (info.level == "error") {
				owner.dispatchError(new MethodInvocationErrorInfo(connectionName, method, MethodInvocationErrorInfo.ERROR_UNKNOWN));
				listener.onError(new MethodInvocationErrorInfo(connectionName, method, MethodInvocationErrorInfo.ERROR_UNKNOWN));
			}
		}
		if (!client.send.apply(client, [connectionName, method].concat(args)))
			throw new MethodInvocationException("Arguments [" + args + "] are out of size.", this, arguments);
	}
	
	/**
	 * Dispatches the occured error to all registered MethodInvocationErrorListeners.
	 *
	 * @param info a MethodInvocationErrorInfo instance that contains further information about the error
	 */
	private function dispatchError(info:MethodInvocationErrorInfo) {
		errorBroadcaster.dispatch(info);
	}
	
	/**
	 * @see LocalConnectionTemplate#addErrorListener()
	 */
	public function addErrorListener(listener:MethodInvocationErrorListener):Void {
		errorBroadcaster.addListener(listener);
	}
	
	/**
	 * @see LocalConnectionTemplate#removeErrorListener()
	 */
	public function removeErrorListener(listener:MethodInvocationErrorListener):Void {
		errorBroadcaster.removeListener(listener);
	}
	
}