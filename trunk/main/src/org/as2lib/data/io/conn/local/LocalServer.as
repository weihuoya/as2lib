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
import org.as2lib.data.io.conn.local.ReservedConnectionException;
import org.as2lib.data.io.conn.local.MissingClientsException;
import org.as2lib.data.io.conn.local.MissingClientException;
import org.as2lib.data.io.conn.local.NotAllowedDomainException;
import org.as2lib.data.io.conn.local.ClientStatusListener;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.OutAccess;
import org.as2lib.util.ObjectUtil;
import org.as2lib.Config;

/**
 * LocalServer is a LocalConnection server, who is able to add clients and broadcast
 * messages to all clients.
 *
 * @author Christoph Atteneder
 */
class org.as2lib.data.io.conn.local.LocalServer extends LocalConnection implements Connector {
	
	/* EventBroadcaster for onResponse and onError - events */
	private var eventBroadcaster:EventBroadcaster;
	
	/** 
	 * Defines domain of which client should be allowed
	 */
	private var host:String;
	
	/** 
	 * Defines additional domain of which client should be allowed
	 */
	private var path:String;
	
	/* name of method, which should be passed to a client */
	private var method:String;
	
	/* Parameters, which should be passed */
	private var params:Array;
	
	/**
	 * String, which method on the clients is accessed 
	 * @see LocalServer constructor
	 */
	private static var CLIENT_METHOD:String = "clientMethod";
	
	/* LocalConnection object for broadcasting messages */
	private var sender:LocalConnection;
	
	/* Stores domain, used by allowDomain, for security */
	//private var domain:String;

	/* List of clients and their StatusListener Objects*/
	private var clients:HashMap;
	
	/* Standard debug output */
	private var aOut:OutAccess;
	
	//private var currClient:String;
	
	/*private var cacheClient:String;
	private var connTests:Number = 10;*/
	
	/**
	 * Constructs a new LocalServer instance.
	 * Initializes array for parameters, list of clients, the out object and
	 * the method, which is called on the clients.
	 */
	public function LocalServer(Void) {
		aOut = Config.getOut();
		aOut.debug(getClass().getName()+" - Constructor");
		
		eventBroadcaster = Config.getEventBroadcasterFactory().createEventBroadcaster();
		params = new Array();
		clients = new HashMap();
	}
	
	/**
	 * Inits LocalConnection. Listens to a LocalConnection with id "register", which is 
	 * used by LocalClients to establish a connection to LocalServer
	 */
	public function initConnection(Void):Void {
		aOut.debug(getClass().getName()+".initConnection");
		if(!connect("register")){
			eventBroadcaster.dispatch(new ConnectorError(new ReservedConnectionException("Connection name 'register' is already used by another LocalConnection",this,arguments)));
		}
	}
	
	/**
	 * Adds a LocalClient, which tries to connect through LocalConnection with
	 * id "register". If the client doesn´t exists in the client list it is added.
	 * @param id a String, which represents the LocalConnection through
	 * 			 which a connection from the server can be established.
	 */
	public function addClient(id:String):Void{
		aOut.debug(getClass().getName()+".addClient: "+id);
		
		if(clients.containsKey(id)) return;

		clients.put(id,new ClientStatusListener(this,id));
		eventBroadcaster.dispatch(new ConnectorResponse(getClass().getName()+".addClient on "+id+" with an ClientStatusListener"));
	}
	
	/**
	 * Sends data to clients. The data can include a name of a method and its
	 * parameters.
	 */
	private function broadcast(Void):Void{
		aOut.debug(getClass().getName()+".broadcast");
		
		if(clients.isEmpty()){
			eventBroadcaster.dispatch(new ConnectorError(new MissingClientsException("LocalServer has no clients to broadcast !",this,arguments)));
			return;
		}
		
		var args:Array = new Array();
		sender = new LocalConnection();
		
		aOut.debug(getClass().getName()+".clients.length:"+clients.size());
		
		args.push(CLIENT_METHOD);
		args.push(method);
		args = args.concat(params);
		
		var keys:Array = clients.getKeys();
		var it:Iterator = clients.iterator();
		
		while(it.hasNext()){
			var listenerObj:ClientStatusListener = it.next();
			var key:String = String(keys.shift());
			aOut.debug(getClass().getName()+".broadcast: "+listenerObj.getClass().getName()+" @ "+key);
			sender.send.apply(listenerObj,[key].concat(args));
			//sender.send.apply(this,[key].concat(args));
		}
	}
	
	/**
	 * Method which is called by clients to communicate with the server.
	 * @params as many as possible
	 */
	public function serverMethod():Void {
		aOut.debug(arguments.toString());
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
	 * Sets additional path. In case of LocalConnection a possible second domain
	 *  to restrict domain access.
	 * @param path an url representing allowed domain (e.g. "www.as2lib.org")
	 */
	public function setPath(path:String):Void {
		this.path = path;
	}
	
	/**
	 * Returns path/domain
	 * @return path an url representing allowed domain (e.g. "www.as2lib.org")
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
	 * Is called if an error occured while trying to establish a connection.
	 * If an error is caught it is tried again to connect until an connection 
	 * is established or tries are timed out.
	 * @see initConnection
	 * @param infoObj  can be used to identify error/ in this case only infoObj.level="error" is possible
	 */
	public function statusDispatch(infoObj,id:String){
		aOut.debug(getClass().getName()+".statusDispatch: "+infoObj.level);
		if(infoObj.level == "error") {
			eventBroadcaster.dispatch(new ConnectorError(new MissingClientException("Client "+id+" doesn´t exist anymore !",this,arguments)));
		}
		if(infoObj.level == "status") {
			eventBroadcaster.dispatch(new ConnectorResponse("Broadcast to client "+id+" was successful!"));
		}
	}
	
	/**
	 * Is called when a client tries to connect to server. It checks if the client is from an
	 * allowed domain.
	 * @param clientDomain  domain from sending client
	 */
	public function allowDomain(clientDomain:String){
		aOut.debug(getClass().getName()+".allowDomain: "+clientDomain);
		aOut.debug(getClass().getName()+".host: "+host);
		aOut.debug(getClass().getName()+".path: "+path);
		if(host){
			if(clientDomain == host || clientDomain == path){
				return true;
			}
			else{
				eventBroadcaster.dispatch(new ConnectorError(new NotAllowedDomainException("Clientdomain "+clientDomain+" is not allowed !",this,arguments)));
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
		aOut.debug(getClass().getName()+".handleRequest.getHost: "+getHost());
		var h:String = r.getHost();
		var p:String = r.getPath();
		var m:String = r.getMethod();
		var a:Array = r.getParams();
		
		if(h) host = h;
		if(p) path = p;
		if(m) {
			method = m;
			params = a;
			broadcast();
		}
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
	 * is obtained via the Stringifier obtained from the ObjectUtil#getStringifier()
	 * operation.
	 *
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return ObjectUtil.getStringifier().execute(this);
	}
}