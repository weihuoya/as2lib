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
 
import org.as2lib.data.io.conn.Connector;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorRequest;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;
import org.as2lib.Config;
import org.as2lib.env.out.OutAccess;
import org.as2lib.data.io.conn.local.ReservedConnectionException;
import org.as2lib.data.io.conn.local.NotAllowedDomainException;
import org.as2lib.data.io.conn.local.MissingServerException;

/**
 * LocalClient is a LocalConnection client, who is able to connect to a server and send
 * messages to the server.
 *
 * @author Christoph Atteneder
 */

class org.as2lib.data.io.conn.local.LocalClient extends LocalConnection implements Connector {
	
	/* EventBroadcaster for onResponse and onError - events */
	private var eventBroadcaster:EventBroadcaster;
	
	/* Defines domain of which server should be allowed */
	private var host:String;
	
	/* Additional Parameter, which can be used */
	private var path:String;
	
	/* name of method, which should be passed to a server */
	private var method:String;
	
	/* Parameters, which should be passed */
	private var params:Array;
	
	/* Standard debug output */
	private var aOut:OutAccess;
	
	/* LocalConnection object for broadcasting messages */
	private var sender:LocalConnection;
	
	/* Name of method, which is accessed on server */
	private var serverMethod:String = "serverMethod";
	
	/* Name of method, which is accessed to add a client at the server */
	private var addClientMethod:String = "addClient";
	
	/* Name of connection, which is used to connect to server */
	private var serverID = "register";
	
	/* Name of client connection */
	private var connID:String;
	
	/**
	 * Constructs a new LocalClient instance.
	 * Initializes EventBroadcaster, array for parameters, list of clients and the out object.
	 */
	public function LocalClient(Void) {
		aOut.debug(getClass().getName()+"- Constructor");
		
		eventBroadcaster = Config.getEventBroadcasterFactory().createEventBroadcaster();
		params = new Array();
		aOut = Config.getOut();
	}
	
	/**
	 * Inits LocalConnection and tries to connect to a LocalServer.
	 */
	public function initConnection(Void):Void {
		aOut.debug(getClass().getName()+".initConnection");
		
		connID = getRandomID();
		
		sender = new LocalConnection();
		
		var args:Array = new Array(serverID,addClientMethod,connID);
		sender.send.apply(this,args);
		if(!connect(connID)){
			eventBroadcaster.dispatch(new ConnectorError(new ReservedConnectionException("Connection name '"+connID+"' is already used by another LocalConnection",this,arguments)));
			//initConnection();
		}
	}
	
	/**
	 * Returns an random connection identifier.
	 * @return result a String, which represents the LocalConnection through
	 * 			 which a connection from the server to the clientvcan be established.
	 */
	private function getRandomID(Void):String {
		aOut.debug(getClass().getName()+".getRandomID");
        var s:String = "abcdefghijklmnopqrstuvwxyz";
        var cnt:Number = 10;
		var result:String = new String("conn_");
        while (cnt--) {
            result += s.charAt(Math.floor(Math.random() * s.length));
        }
        return result;
    }
	
	/**
	 * Method which is called by a server to communicate with the client.
	 * @params as many as possible
	 */
	public function clientMethod():Void {
		aOut.debug(getClass().getName()+".clientMethod");
		eventBroadcaster.dispatch(new ConnectorResponse(arguments));
	}
	
	/**
	 * Sets domain name to activate allowDomain functionality
	 * @see allowDomain
	 * @params host an url representing allowed domains (e.g. "www.as2lib.org")
	 */
	public function setHost(host:String):Void {
		this.host = host;
	}
	
	/**
	 * Returns host/domain
	 * @return host an url representing allowed domain (e.g. "www.as2lib.org")
	 */
	public function getHost(Void):String {
		return host;
	}
	
	/**
	 * Sets additional transer parameter.
	 * @param path optional parameter
	 */
	public function setPath(path:String):Void {
		this.path = path;
	}
	
	/**
	 * Returns path
	 * @return path optional parameter
	 */
	public function getPath(Void):String {
		return path;
	}
	
	/**
	 * Sets method, which should be passed to client/s
	 * @param method  name of the method (e.g "draw)
	 */
	public function setMethod(method:String):Void {
		this.method = method;
	}
	
	/**
	 * Returns method
	 * @return method name of the method
	 */
	public function getMethod(Void):String {
		return method;
	}	

	/**
	 * Sets parameters, which should be passed to client/s
	 * @param arguments  all arguments that are passed to clients
	 */
	public function setParams():Void {
		
		params = arguments;
	}
	
	/**
	 * Returns parameters
	 * @return params parameters, which should be passed to clients
	 */
	public function getParams(Void):Array {
		return params;
	}

	/**
	 * Sends data to a server. The data can include a name of a method and its
	 * parameters.
	 */
	private function broadcast(Void):Void{
		aOut.debug(getClass().getName()+".broadcast");
		
		var args:Array = new Array();
		sender = new LocalConnection();
		
		args.push(serverID);
		args.push(serverMethod);
		
		if(path)args.push(path);
		
		args.push(connID);
		args.push(method);
		args = args.concat(params);
		
		sender.send.apply(this,args);
	}
	
	/**
	 * Is called after established or tried to establish a LocalConnection.
	 */
	public function onStatus(infoObj){
		aOut.debug(getClass().getName()+".onStatus: "+infoObj.level);
		if(infoObj.level == "error") {;
			eventBroadcaster.dispatch(new ConnectorError(new MissingServerException("There is no server with a 'register' connection to listen to !",this,arguments,true,false)));
		}
		if(infoObj.level == "status") {
			eventBroadcaster.dispatch(new ConnectorResponse("Clientbroadcast was successful!"));
		}
	}
	
	/**
	 * Is called when a client tries to connect to server. It checks if the client is from an
	 * allowed domain.
	 * @param clientDomain  domain from sending client
	 */
	public function allowDomain(serverDomain:String){
		aOut.debug(getClass().getName()+".allowDomain: "+serverDomain);
		aOut.debug(getClass().getName()+".host: "+host);
		if(host){
			if(serverDomain == host){
				return true;
			}
			else{
				eventBroadcaster.dispatch(new ConnectorError(new NotAllowedDomainException("ServerDomain "+serverDomain+" is not allowed !",this,arguments)));
				return false;
			}
		}
		else{
			return true;
		}
	}
	
	/**
	 * @see org.as2lib.data.io.conn.Connector
	 */
	public function addListener(l:ConnectorListener):Void {
		aOut.debug(getClass().getName()+".addListener");
		eventBroadcaster.addListener(l);
	}
	
	/**
	 * @see org.as2lib.data.io.conn.Connector
	 */
	public function removeListener(l:ConnectorListener):Void {
		aOut.debug(getClass().getName()+".removeListener");
		eventBroadcaster.removeListener(l);
	}
	
	/**
	 * @see org.as2lib.data.io.conn.Connector
	 */
	public function handleRequest(r:ConnectorRequest):Void {
		aOut.debug(getClass().getName()+".handleRequest");
		var h:String = r.getHost();
		var p:String = r.getPath();
		var m:String = r.getMethod();
		var a:Array = r.getParams();
		
		if(h) host = h;
		if(p) path = p;
		if(m) {
			method = m;
			params = a;
		}

		broadcast();
	}
	
	/**
	 * Uses the ReflectUtil#getClassInfo() operation to fulfill the task.
	 *
	 * @see org.as2lib.core.BasicInterface#getClass()
	 * @see org.as2lib.env.util.ReflectUtil;
	 */
	public function getClass(Void):ClassInfo {
		return ReflectUtil.getClassInfo(this);
	}
	
	/**
	 * Returns a String representation of the instance. The String representation
	 * is obtained via the Stringifier obtained from the Config#getObjectStringifier()
	 * operation.
	 *
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return Config.getObjectStringifier().execute(this);
	}
}