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
 * @author Christoph Atteneder
 * @version 1.0
 * @date 13.05.2004
 */

class org.as2lib.data.io.conn.local.LocalClient extends LocalConnection implements Connector {
	
	/* EventBroadcaster for onResponse and onError - events */
	private var eventBroadcaster:EventBroadcaster;
	
	/** 
	 * Defines domain of which server should be allowed
	 */
	private var host:String;
	
	/** 
	 * Defines additional domain of which server should be allowed
	 */
	private var path:String;
	
	private var method:String;
	
	private var params:Array;
	
	private var aOut:OutAccess;
	
	private var sender:LocalConnection;
	
	/* LocalConnection object for connection */
	//private var sender:LocalConnection;
	private var connID:String;
	
	/* stores domain, used by allowDomain, for security */
	private var domain:String;
	
	public function LocalClient(Void) {
		aOut.debug(getClass().getName()+"- Constructor");
		
		eventBroadcaster = Config.getEventBroadcasterFactory().createEventBroadcaster();
		params = new Array();
		aOut = Config.getOut();
	}
	
	public function initConnection(Void):Void {
		aOut.debug(getClass().getName()+".initConnection");
		
		connID = getRandomID();
		
		sender = new LocalConnection();
		
		var args:Array = new Array("register","addClient",connID);
		sender.send.apply(this,args);
		if(!connect(connID)){
			eventBroadcaster.dispatch(new ConnectorError(new ReservedConnectionException("Connection name '"+connID+"' is already used by another LocalConnection",this,arguments)));
		}
	}
	
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
	
	public function clientMethod():Void {
		aOut.debug(getClass().getName()+".clientMethod");
		eventBroadcaster.dispatch(new ConnectorResponse(arguments));
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
	
	public function getParams(Void):Array {
		return params;
	}
	
	public function setParams():Void {
		
		params = arguments;
	}
	
	public function onStatus(infoObj){
		aOut.debug(getClass().getName()+".onStatus: "+infoObj.level);
		if(infoObj.level == "error") {;
			eventBroadcaster.dispatch(new ConnectorError(new MissingServerException("There is no server with a 'register' connection to listen to !",this,arguments,true,false)));
		}
		/*if(infoObj.level == "status") {
			eventBroadcaster.dispatch(new ConnectorResponse("Serverbroadcast was successful!"));
		}*/
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
		}

		initConnection();
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