import org.as2lib.data.io.conn.Connector;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorRequest;
import org.as2lib.data.io.conn.local.LocalRequest;
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
	private var connId:String;
	
	/* LocalConnection object for connection */
	private var loc:LocalConnection;
	
	/* stores domain, used by allowDomain, for security */
	private var domain:String;
	
	public function RemotingConnector(Void) {
		eventBroadcaster = new EventBroadcaster();
		loc = new LocalConnection();
	}
	
	public function initConnection(Void):Void {
		// Nothing to do =)
	}
	public function getIdentifier(Void):String {
		return connId;
	}
	public function setIdentifier(connId:String):Void {
		this.connId = connId;
	}
	
	public function addListener(l:ConnectorListener):Void {
		//trace("addListener");
		eventBroadcaster.addListener(l);
	}
	
	public function removeListener(l:ConnectorListener):Void {
		//trace("removeListener");
		eventBroadcaster.removeListener(l);
	}
	
	public function onResult(data){
		eventBroadcaster.dispatch(new ConnectorResponse(data,this,new FunctionArguments(),true,false));
	}
	
	public function onStatus(info){
		eventBroadcaster.dispatch(new ConnectorError(info.description,this,new FunctionArguments(),true,false));
	}
	
	public function handleRequest(r:ConnectorRequest):Void {
		if(LocalRequest(r).getMethod()){
			loc.send(connId,LocalRequest(r).getMethod());
		}
		else{
			loc.connect(connId);
		}
	}
}