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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.io.conn.core.event.MethodInvocationErrorListener;
import org.as2lib.io.conn.core.event.MethodInvocationErrorInfo;
import org.as2lib.io.conn.core.client.MethodInvocationException;
import org.as2lib.io.conn.local.core.ReservedConnectionException;
import org.as2lib.io.conn.local.core.UnknownConnectionException;

/**
 * EnhancedLocalConnection provides enhanced local connection
 * functionalities.
 *
 * <p>These functionalities are proper listener support for asynchronous
 * failures and comprehensible exceptions on synchronous errors like
 * reserved and unknown connections and oversized arguments.
 * Refer to the specific method for further explanations.
 *
 * <p>You set up a connection to receive 'remote' method invocations
 * as follows:
 * <code>
 * var service:EnhancedLocalConnection = new EnhancedLocalConnection();
 * service["myMethod"] = function(myArg1:String, myArg2:String):Void {
 *   trace("invoked myMethod(" + myArg1 + ", " + myArg2 + ")");
 * }
 * service.connect("myService");
 * </code>
 *
 * <p>While the above example works it is not as neat as it can be. It
 * would be better to use another instance as service and the connection
 * only to set it up to receive 'remote' method calls.
 * <code>
 * var service:MyService = new MyService();
 * var connection:EnhancedLocalConnection = new EnhancedLocalConnection(service);
 * connection.connect("myService");
 * </code>
 *
 * <p>The service is set up now to receive 'remote' method invocations.
 * You can now invoke a method on it as follows:
 * <code>
 * var client:EnhancedLocalConnection = new EnhancedLocalConnection();
 * var listener:MethodInvocationErrorListener = client.send("myService", "myMethod", ["arg1", "arg2"]);
 * listener.onError = function(errorInfo:MethodInvocationErrorInfo):Void {
 *   trace("Error occured: " + errorInfo); 
 * }
 * </code>
 *
 * @author Simon Wacker
 * @author Christoph Atteneder
 */
class org.as2lib.io.conn.local.core.EnhancedLocalConnection extends BasicClass {
	
	/** Target that gets used as server. */
	private var target:Object;
	
	/** Indicates whether the connection is open (true) or closed (false). */
	private var connected:Boolean;
	
	/** Stores added MethodInvocationErrorListener. */
	private var errorBroadcaster:EventBroadcaster;
	
	/** Stores clients waiting for status reports. */
	private var clientArray:Array;
	
	/**
	 * Checks if a connection with the passed-in connection name exists.
	 *
	 * <p>Returns false if the connection name is null, undefined or a blank
	 * string.
	 * 
	 * @param connectionName the name of the connection
	 * @return true if connection exists else false
	 */
	public static function connectionExists(connectionName:String):Boolean {
		if (!connectionName) return false;
		var lc:LocalConnection = new LocalConnection();
		var result:Boolean = !lc.connect(connectionName);
		lc.close();
		return result;
	}
	
	/**
	 * @overload #EnhancedLocalConnectionByVoid(Void):Void
	 * @overload #EnhancedLocalConnectionByTarget(*):Void
	 */
	public function EnhancedLocalConnection() {
		var o:Overload = new Overload(this);
		o.addHandler([], EnhancedLocalConnectionByVoid);
		o.addHandler([Object], EnhancedLocalConnectionByTarget);
		o.forward(arguments);
	}
	
	/**
	 * Constructs a new EnhancedLocalConnectionByVoid instance.
	 *
	 * <p>The target gets set to this.
	 */
	private function EnhancedLocalConnectionByVoid(Void):Void {
		EnhancedLocalConnectionByTarget(this);
	}
	
	/**
	 * Constructs a new EnhancedLocalConnectionByTarget instance with target.
	 *
	 * <p>If the target is null or undefined, the target will be set to this.
	 * 
	 * @param target to be used as server when creating a new connection
	 */
	private function EnhancedLocalConnectionByTarget(target):Void {
		this.target = target ? target : this;
		connected = false;
		errorBroadcaster = new SpeedEventBroadcaster();
		clientArray = new Array();
	}
	
	/**
	 * Prepares the connection to receive 'remote' method invocations.
	 *
	 * <p>Closes the connection if it is currenlty running and opens the
	 * new one.
	 *
	 * <p>If you specified a target, the 'remote' method invocations will
	 * be led directly to it.
	 *
	 * @param connectionName name of the connection the client uses to send method calls
	 * @throws IllegalArgumentException if the connection name is null, undefined or an empty string
	 * @throws ReservedConnectionException if a connection with the passed-in name is already in use
	 */
	public function connect(connectionName:String):Void {
		if (!connectionName) throw new IllegalArgumentException("Name of connection must not be null, undefined or an empty string.", this, arguments);
		if (connected) close();
		if (!LocalConnection.prototype.connect.apply(target, [connectionName]))
			throw new ReservedConnectionException("Connection with name [" + connectionName + "] is already in use.", this, arguments);
		connected = true;
	}
	
	/**
	 * Closes the connection.
	 */
	public function close(Void):Void {
		LocalConnection.prototype.close.apply(target);
		connected = false;
	}
	
	/**
	 * @overload #sendByConnectionAndMethod(String, String):Void
	 * @overload #sendByConnectionAndMethodAndArguments(String, String, Array):Void
	 * @overload #sendByConnectionAndMethodandListener(String, String, MethodInvocationErrorListener):Void
	 * @overload #sendByConnectionAndMethodAndArgumentsAndListener(String, String, Array, MethodInvocationErrorListener):Void
	 */
	public function send():MethodInvocationErrorListener {
		var o:Overload = new Overload(this);
		o.addHandler([String, String], sendByConnectionAndMethod);
		o.addHandler([String, String, Array], sendByConnectionAndMethodAndArguments);
		o.addHandler([String, String, MethodInvocationErrorListener], sendByConnectionAndMethodAndListener);
		o.addHandler([String, String, Array, MethodInvocationErrorListener], sendByConnectionAndMethodAndArgumentsAndListener);
		return o.forward(arguments);
	}
	
	/**
	 * Invokes a method remotely on the connection specified by the connection
	 * name passing the arguments as parameters.
	 *
	 * <p>Error listeners get informed if the 'remote' method invocation
	 * failed asynchron of an unknown reason.
	 *
	 * <p>A new MethodInvocationErrorListener instance gets created and
	 * returned. You can set the onError(..) method on it to get informed
	 * of occuring errors.
	 *
	 * @param connectionName the name of the connection to invoke a method on
	 * @param methodName the name of the method to invoke on the connection
	 * @return an error listener that informs you of occuring errors if you set the onError(..) method on it
	 * @throws IllegalArgumentException if the connection name is null, undefined or an empty string
	 *                                  if the method name is null, undefined or an empty string
	 * @throws UnknownConnectionException if a connection with the passed-in connection name does not exist
	 * @throws MethodInvocationException if the arguments you try to pass or out of size
	 */
	public function sendByConnectionAndMethod(connectionName:String, methodName:String):MethodInvocationErrorListener {
		return sendByConnectionAndMethodAndArgumentsAndListener(connectionName, methodName, [], null);
	}
	
	/**
	 * Invokes a method remotely on the connection specified by the connection
	 * name passing the arguments as parameters.
	 *
	 * <p>Error listeners get informed if the 'remote' method invocation
	 * failed asynchron of an unknown reason.
	 *
	 * <p>A new MethodInvocationErrorListener instance gets created and
	 * returned. You can set the onError(..) method on it to get informed
	 * of occuring errors.
	 *
	 * @param connectionName the name of the connection to invoke a method on
	 * @param methodName the name of the method to invoke on the connection
	 * @param args the arguments to pass as parameters when invoking the connection
	 * @return an error listener that informs you of occuring errors if you set the onError(..) method on it
	 * @throws IllegalArgumentException if the connection name is null, undefined or an empty string
	 *                                  if the method name is null, undefined or an empty string
	 * @throws UnknownConnectionException if a connection with the passed-in connection name does not exist
	 * @throws MethodInvocationException if the arguments you try to pass or out of size
	 */
	public function sendByConnectionAndMethodAndArguments(connectionName:String, methodName:String, args:Array):MethodInvocationErrorListener {
		return sendByConnectionAndMethodAndArgumentsAndListener(connectionName, methodName, args, null);
	}
	
	/**
	 * Invokes a method remotely on the connection specified by the connection
	 * name passing the arguments as parameters.
	 *
	 * <p>Error listeners get informed if the 'remote' method invocation
	 * failed asynchron of an unknown reason.
	 *
	 * <p>A new MethodInvocationErrorListener instance gets created and
	 * returned. You can set the onError(..) method on it to get informed
	 * of occuring errors.
	 *
	 * @param connectionName the name of the connection to invoke a method on
	 * @param methodName the name of the method to invoke on the connection
	 * @param listener the listener to notify if the method invocation failed out of an asynchron unknwon reason
	 * @return an error listener that informs you of occuring errors if you set the onError(..) method on it
	 * @throws IllegalArgumentException if the connection name is null, undefined or an empty string
	 *                                  if the method name is null, undefined or an empty string
	 * @throws UnknownConnectionException if a connection with the passed-in connection name does not exist
	 * @throws MethodInvocationException if the arguments you try to pass or out of size
	 */
	public function sendByConnectionAndMethodAndListener(connectionName:String, methodName:String, listener:MethodInvocationErrorListener):MethodInvocationErrorListener {
		return sendByConnectionAndMethodAndArgumentsAndListener(connectionName, methodName, [], listener);
	}
	
	/**
	 * Invokes a method remotely on the connection specified by the connection
	 * name passing the arguments as parameters.
	 *
	 * <p>Error listeners get informed if the 'remote' method invocation
	 * failed asynchron of an unknown reason.
	 *
	 * <p>If the passed-in listener is null a new gets created and returned.
	 * You can still set the onError(..) method on it even after this method
	 * was invoked.
	 *
	 * @param connectionName the name of the connection to invoke a method on
	 * @param methodName the name of the method to invoke on the connection
	 * @param args the arguments to pass as parameters when invoking the connection
	 * @param listener the listener to notify if the method invocation failed out of an asynchron unknwon reason
	 * @return either the passed-in listener if it was not null or undefined, or a new listener of type MethodInvocationErrorListener
	 * @throws IllegalArgumentException if the connection name is null, undefined or an empty string
	 *                                  if the method name is null, undefined or an empty string
	 * @throws UnknownConnectionException if a connection with the passed-in connection name does not exist
	 * @throws MethodInvocationException if the arguments you try to pass or out of size
	 */
	public function sendByConnectionAndMethodAndArgumentsAndListener(connectionName:String, methodName:String, args:Array, listener:MethodInvocationErrorListener):MethodInvocationErrorListener {
		if (!connectionName || !methodName) throw new IllegalArgumentException("Neither the connection name [" + connectionName + "] nor the method name [" + methodName + "] are allowed to be null, undefined or an empty string.", this, arguments);
		if (!connectionExists(connectionName)) throw new UnknownConnectionException("Connection with name [" + connectionName + "] does not exist.", this, arguments);
		if (!args) args = new Array();
		if (!listener) listener = getBlankMethodInvocationErrorListener();
		var client:LocalConnection = new LocalConnection();
		var owner:EnhancedLocalConnection = this;
		// If the client did not get stored the garbage collector would remove it before
		// the onStatus-event would get invoked.
		var index:Number = clientArray.push(client) - 1;
		client.onStatus = function(info) {
			owner.clientArray.splice(index, 1);
			if (info.level == "error") {
				owner.dispatchError(new MethodInvocationErrorInfo(connectionName, methodName, args, MethodInvocationErrorInfo.UNKNOWN_ERROR));
				listener.onError(new MethodInvocationErrorInfo(connectionName, methodName, args, MethodInvocationErrorInfo.UNKNOWN_ERROR));
			}
		}
		if (!client.send.apply(client, [connectionName, methodName].concat(args)))
			throw new MethodInvocationException("Arguments [" + args + "] are out of size.", this, arguments);
		return listener;
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
		result.__constructor__ = MethodInvocationErrorListener;
		return result;
	}
	
	/**
	 * Dispatches the occured error to all registered error listeners.
	 *
	 * @param info that contains further information about the error
	 */
	private function dispatchError(info:MethodInvocationErrorInfo) {
		errorBroadcaster.dispatch(info);
	}
	
	/**
	 * Adds a new error listener.
	 *
	 * <p>Error listener get invoked if an asynchron error occured. That is
	 * mostly when you try to invoke a remote method.
	 *
	 * @param listener the new error listener to add
	 */
	public function addErrorListener(listener:MethodInvocationErrorListener):Void {
		errorBroadcaster.addListener(listener);
	}
	
	/**
	 * Removes an error listener.
	 *
	 * <p>Error listener get invoked if an asynchron error occured. That is
	 * mostly when you try to invoke a remote method.
	 *
	 * @param listener the error listener to remove
	 */
	public function removeErrorListener(listener:MethodInvocationErrorListener):Void {
		errorBroadcaster.removeListener(listener);
	}
	
}