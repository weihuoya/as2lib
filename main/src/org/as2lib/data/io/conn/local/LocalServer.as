import org.as2lib.data.io.conn.Connector;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorRequest;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;

import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;

import org.as2lib.Config;
import org.as2lib.env.out.OutAccess;

import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;

import org.as2lib.data.holder.TypedArray;
import org.as2lib.data.iterator.ArrayIterator;

/**
 * LocalServer is a LocalConnection server, who is able to add clients and broadcast
 * messages to all clients.
 *
 * @author Christoph Atteneder
 * @version 1.0
 * @date 13.05.2004
 */

class org.as2lib.data.io.conn.local.LocalServer extends LocalConnection implements Connector {
	
	/* EventBroadcaster for onResponse and onError - events */
	private var eventBroadcaster:EventBroadcaster;
	
	/** 
	 * Part of connection id used to identify the correct local connection.
	 * In Server not neccessary.
	 */
	private var host:String;
	
	/** 
	 * Part of connection id used to identify the correct local connection.
	 * In Server not neccessary.
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
	private var cMethod:String;
	
	/* LocalConnection object for broadcasting messages */
	private var sender:LocalConnection;
	
	/* Stores domain, used by allowDomain, for security */
	private var domain:String;

	/* List of clients */
	private var clients:TypedArray;
	
	/* Standard debug output */
	private var aOut:OutAccess;
	
	/**
	 * Constructs a new LocalServer instance.
	 * Initializes array for parameters, list of clients, the out object and
	 * the method, which is called on the clients.
	 */
	public function LocalServer(Void) {
		eventBroadcaster = Config.getEventBroadcasterFactory().createEventBroadcaster();
		params = new Array();
		clients = new TypedArray(String);
		aOut = Config.getOut();
		cMethod = "clientMethod";
	}
	
	/**
	 * Inits LocalConnection. Listens to a LocalConnection with id "register", which is 
	 * used by LocalClients to establish a connection to LocalServer
	 */
	public function initConnection(Void):Void {
		aOut.debug("initConnection");
	
		connect("register");
	}
	
	/**
	 * Adds a LocalClient, which tries to connect through LocalConnection with
	 * id "register". If the client doesn´t exists in the client list it is added.
	 * @param id a String, which represents the LocalConnection through
	 * 			 which a connection from the server can be established.
	 */
	public function addClient(id:String):Void{
		aOut.debug("addClient: "+id);
		
		if(clients.contains(id)) return;
		
    	clients.push(id);
		
		aOut.debug("clients.getValue("+(clients.length-1)+") = "+clients.getValue(clients.length-1));
	}
	
	/**
	 * Sends data to clients. The data can include a name of a method and its
	 * parameters.
	 */
	private function dispatch(Void):Void{
		aOut.debug("dispatch");
		
		var l:Number = clients.length;
		var args:Array = new Array();
		sender = new LocalConnection();
		
		aOut.debug("clients.length:"+l);
		
		args.push(cMethod);
		args.push(method);
		args = args.concat(params);
		
		while(l--){
			aOut.debug("dispatch: "+clients.getValue(l));
			sender.send.apply(null,[clients.getValue(l)].concat(args));
		}
	}
	
	public function serverMethod() {
		aOut.debug(arguments.toString());
	}
	
	public function setHost(host:String):Void {
		this.host = host;
	}
	
	public function getHost(Void):String {
		return host;
	}
	
	public function setPath(path:String):Void {
		this.path = path;
	}
	
	public function getPath(Void):String {
		return path;
	}

	public function getMethod(Void):String {
		return method;
	}
	
	public function setMethod(method:String):Void {
		this.method = method;
	}
	
	public function getParams() {
		return params;
	}
	
	public function setParams():Void {
		
		params = arguments;
	}
	
	public function onStatus(infoObj){
		aOut.debug("onStatus: "+infoObj.level);
		/*if (infoObject.level!="error"){
		googleConnection.connect(connectionName);
		connected=true
		}
		else {
			if (tries--){
				searching.text = "Waiting for LocalConnection ("+tries+" attempts left)"
				iv=setInterval(initConnection,1000)
			}
		}*/
		if(infoObj.level == "error") {
			eventBroadcaster.dispatch(new ConnectorError("There is no receiver with this defined connection identifier",this,arguments,true,false));
		}
	}
	
	public function addListener(l:ConnectorListener):Void {
		//trace("addListener");
		eventBroadcaster.addListener(l);
	}
	
	public function removeListener(l:ConnectorListener):Void {
		//trace("removeListener");
		eventBroadcaster.removeListener(l);
	}
	
	public function handleRequest(r:ConnectorRequest):Void {
		var h:String = r.getHost();
		var p:String = r.getPath();
		var m:String = r.getMethod();
		var a:Array = r.getParams();
		
		if(h) host = h;
		if(p) path = p;
		if(m) {
			method = m;
			params = a;
			dispatch();
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