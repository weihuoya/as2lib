import org.as2lib.data.io.conn.Connector;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorRequest;
//import org.as2lib.data.io.conn.local.LocalRequest;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.core.BasicClass;

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

class org.as2lib.data.io.conn.local.LocalConnector extends BasicClass implements Connector {
	
	/* EventBroadcaster for onResponse and onError - events */
	private var eventBroadcaster:EventBroadcaster;
	
	/* connection id used to identify the correct local connection */
	private var host:String;
	
	private var path:String;
	
	private var method:String;
	
	private var params:FunctionArguments;
	
	/* LocalConnection object for connection */
	private var loc:LocalConnection;
	
	/* stores domain, used by allowDomain, for security */
	private var domain:String;
	
	public function LocalConnector(Void) {
		eventBroadcaster = new EventBroadcaster();
		loc = new LocalConnection();
	}
	
	public function initConnection(Void):Void {
		
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
		for(var i=0; i<arguments.length; i++) {
			params.push(arguments[i]);
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
		if(r.getHost()) host = r.getHost();
		if(r.getPath()) path = r.getPath();
		if(r.getMethod()) path = r.getMethod();
		
		/*if(LocalRequest(r).getMethod()){
			loc.send(connId,LocalRequest(r).getMethod());
		}
		else{
			loc.connect(connId);
		}*/
	}
}