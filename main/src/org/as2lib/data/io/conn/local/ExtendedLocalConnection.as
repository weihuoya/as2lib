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
import org.as2lib.util.Call;
import org.as2lib.env.overload.Overload;
import org.as2lib.data.io.conn.local.LocalUtil;
import org.as2lib.data.io.conn.local.ReservedConnectionException;
import org.as2lib.data.io.conn.local.UnknownConnectionException;
import org.as2lib.data.io.conn.local.InvalidMethodCallException;

/**
 * Provides extended LocalConnection functionalities.
 * It provides centralized ExceptionHandling and establishes LocalConnections.
 *
 * @author Christoph Atteneder
 * @author Simon Wacker
 */

class org.as2lib.data.io.conn.local.ExtendedLocalConnection extends BasicClass {
	/** Name of LocalConnection */
	private var connectionName:String;
	/** Used LocalConnection instance */
	private var connection:LocalConnection;
	/** object for handling connection problems. In most cases set to ExtendedLocalConnection instance.*/
	private var target:Object;
	
	/** ExtendedLocalConnection instance */
	private var responseServer;
	
	/**
	 * Checks if a LocalConnection with the passed identifier exists.
	 * 
	 * @param connection String
	 * @return true if connection exists 
	 */
	public static function connectionExists(connectionName:String):Boolean {
		var lc:LocalConnection = new LocalConnection();
		var result:Boolean = !lc.connect(connectionName);
		lc.close();
		return result;
	}
	
	/**
	 * Overload
	 * #ExtendedLocalConnectionWithTarget()
	 * #ExtendedLocalConnectionWithoutTarget()
	 */
	public function ExtendedLocalConnection() {
		var o:Overload = new Overload(this);
		o.addHandler([Object], ExtendedLocalConnectionWithTarget);
		o.addHandler([], ExtendedLocalConnectionWithoutTarget);
		o.forward(arguments);
	}
	
	/**
	 * Constructor for ExtendedLocalConnection with passed target
	 * 
	 * @param target for catching onStatus Events
	 */
	public function ExtendedLocalConnectionWithTarget(target):Void {
		this.target = target;
		connection = new LocalConnection();
	}
	
	/**
	 * Constructor for ExtendedLocalConnection
	 */
	public function ExtendedLocalConnectionWithoutTarget(Void):Void {
		ExtendedLocalConnectionWithTarget(this);
	}
	
	/**
	 * Establishes LocalConnection with passed connection identifier.
	 * throws ReservedConnectionException
	 * 
	 * @param connectionName LocalConnection identifier
	 */
	public function connect(connectionName:String):Void {
		if (!connection.connect.apply(target, [connectionName])) {
			throw new ReservedConnectionException("Connection with connection name [" + connectionName + "] is already in use.", this, arguments);
		}
	}
	
	/**
	 * Overload
	 * #sendWithoutArgsAndResponse()
	 * #sendWithArgs()
	 * #sendWithResponse()
	 * #sendWithArgsAndResponse()
	 */
	public function send():Void {
		var o:Overload = new Overload(this);
		o.addHandler([String, String], sendWithoutArgsAndResponse);
		o.addHandler([String, String, Array], sendWithArgs);
		o.addHandler([String, String, Call], sendWithResponse);
		o.addHandler([String, String, Array, Call], sendWithArgsAndResponse);
		o.forward(arguments);
	}
	
	/**
	 * Invokes method on LocalConnection object with passed identifier.
	 * 
	 * @param connectionName LocalConnection identifier
	 * @param method which should be invoked
	 */
	public function sendWithoutArgsAndResponse(connectionName:String, method:String):Void {
		sendWithArgs(connectionName, method, []);
	}
	
	/**
	 * Invokes method and passes arguments on LocalConnection object with passed identifier.
	 * 
	 * @param connectionName LocalConnection identifier
	 * @param method which should be invoked
	 * @param args arguments which should be passed
	 */
	public function sendWithArgs(connectionName:String, method:String, args:Array):Void {
		this.connectionName = connectionName;
		if (!connection.send.apply(target, [connectionName, method].concat(args))) {
			throw new InvalidMethodCallException("Passed arguments [" + args + "] are out of size.", this, arguments);
		}
	}
	
	/**
	 * Invokes method on LocalConnection object with passed identifier and sends Response to Call instance.
	 * 
	 * @param connectionName LocalConnection identifier
	 * @param method which should be invoked
	 * @param call  which is called after response
	 */
	public function sendWithResponse(connectionName:String, method:String, call:Call):Void {
		sendWithArgsAndResponse(connectionName, method, [], call);
	}
	
	/**
	 * Invokes method and passes arguments on LocalConnection object with passed identifier and sends Response to Call instance.
	 * 
	 * @param connectionName LocalConnection identifier
	 * @param method which should be invoked
	 * @param args arguments which should be passed
	 * @param call  which is called after response
	 */
	public function sendWithArgsAndResponse(connectionName:String, method:String, args:Array, call:Call):Void {
		var responseServerString:String = LocalUtil.generateResponseId(connectionName, method);
		
		responseServer = new ExtendedLocalConnection();
		responseServer.call = call;
		responseServer.onResponse = function(response):Void {
			this.call.execute([response]);
			this.close();
		}
		responseServer.connect(responseServerString);

		args.push(responseServerString);
		
		sendWithArgs(connectionName, method, args);
	}
	
	/**
	 * Closes opened LocalConnection.
	 */
	public function close(Void):Void {
		connection.close();
	}
	
	/**
	 * Event is called everytime a send method is invoked.
	 * throws a UnknownConnectionException if a not existing connection identifier is passed.
	 */
	private function onStatus(info):Void {
		if (info.level == "error") {
			throw new UnknownConnectionException("Connection with connection name [" + connectionName + "] does not exist.", this, arguments);
		}
	}
}