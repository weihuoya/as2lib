import org.as2lib.data.io.conn.Connector;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorRequest;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
//import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;
import org.as2lib.Config;
import org.as2lib.env.out.OutAccess;

/**
 * @author Christoph Atteneder
 * @version 1.0
 * @date 30.04.2004
 */

class org.as2lib.data.io.conn.local.LocalClient extends LocalConnection implements Connector {
	
	/* EventBroadcaster for onResponse and onError - events */
	private var eventBroadcaster:EventBroadcaster;
	
	/* connection id used to identify the correct local connection */
	private var host:String;
	
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
		eventBroadcaster = Config.getEventBroadcasterFactory().createEventBroadcaster();
		params = new Array();
		aOut = Config.getOut();
	}
	
	public function initConnection(Void):Void {
		aOut.debug("initConnection");
		connID = getRandomID();
		sender = new LocalConnection();
		//sender.name = "lc"+Number(new Date());
		//lc.connect(lc.name);
		sender.send("register","addClient", connID);
		connect(connID);
		//sender.send("register","addClient", getRandomID());
	}
	
	/*public function onServerStarted():Void {
		
	}*/
	
	public function getRandomID(Void):String {
        var s:String = "abcdefghijklmnopqrstuvwxyz";
        var cnt:Number = 10;
		var result:String = new String(host + path+"_");
        while (cnt--) {
            result += s.charAt(Math.floor(Math.random() * s.length));
        }
        return result;
    }
	
	public function clientMethod() {
		//params = arguments;
		_root.output_txt.text=arguments.toString();
		aOut.debug("clientMethod");
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