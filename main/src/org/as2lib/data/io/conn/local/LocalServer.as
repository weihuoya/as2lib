import org.as2lib.data.io.conn.Connector;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorRequest;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;

import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;

import org.as2lib.Config;
import org.as2lib.env.out.OutAccess;

//import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;

/**
 * Ideas: functionality to automatic call send method after a specific time
 * Functionality of LocalConnection:
 * LC.send(conName, method [, p1,...,pN]):Boolean;
 * LC.send returns true if syntax was correct, it doesn´t
 * mean that a successful connection has been established.
 * If you want to check the connection you have to use the
 * onStatus() method. Also you have a size restriction of passed
 * data.
 * LC.connect();
 * LC.close();
 * LC.allowDomain
 * LC.allowInsecureDomain
 * LC.onStatus();
 * LC.domain();
 *
 * @author Christoph Atteneder
 * @version 1.0
 * @date 30.04.2004
 */

class org.as2lib.data.io.conn.local.LocalServer extends LocalConnection implements Connector {
	
	/* EventBroadcaster for onResponse and onError - events */
	private var eventBroadcaster:EventBroadcaster;
	
	/* connection id used to identify the correct local connection */
	private var host:String;
	
	private var path:String;
	
	private var method:String;
	private var cMethod:String;
	
	private var params:Array;
	
	/* LocalConnection object for connection */
	private var sender:LocalConnection;
	
	/* stores domain, used by allowDomain, for security */
	private var domain:String;

	private var clients:Array;
	
	private var aOut:OutAccess;
	
	public function LocalServer(Void) {
		eventBroadcaster = Config.getEventBroadcasterFactory().createEventBroadcaster();
		params = new Array();
		clients = new Array();
		aOut = Config.getOut();
		cMethod = "clientMethod";
	}
	
	public function initConnection(Void):Void {
		aOut.debug("initConnection");
		
		//receiver = new LocalConnection();
		connect("register");
		
		//sender = new LocalConnection();
        //sender.onStatus = onStatus;
	}
	
	public function addClient(name:String):Void{
		aOut.debug("addClient: "+name);
		var l:Number = clients.length;
    	while(l--){
			if(clients[l]==name) return;
    	}
    	clients.push(name);
		aOut.debug("clients["+(clients.length-1)+"] = "+clients[clients.length-1]);
	}
	
	private function dispatch(Void):Void{
		sender = new LocalConnection();
		aOut.debug("dispatch");
		var l:Number = clients.length;
		aOut.debug("length:"+l);
		var args:Array = new Array();
		args.push(cMethod);
		args.push(method);
		args = args.concat(params);
		while(l--){
			aOut.debug("dispatch: "+clients[l]);
			sender.send.apply(null,[clients[l]].concat(args));
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