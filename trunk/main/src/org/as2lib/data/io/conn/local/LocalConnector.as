import org.as2lib.data.io.conn.Connector;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorRequest;
import org.as2lib.data.io.conn.local.LocalRequest;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.core.BasicClass;

class org.as2lib.data.io.conn.local.LocalConnector extends BasicClass implements Connector {
	
	private var eventBroadcaster:EventBroadcaster;
	private var connId:String;
	private var loc:LocalConnection;
	
	public function RemotingConnector(Void) {
		eventBroadcaster = new EventBroadcaster();
		loc = new LocalConnection();
	}
	
	public function initConnection(Void):Void {
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
	
	/*public function getEventBroadcaster(Void):EventBroadcaster {
		//trace("getEventBroadcaster");
		return eventBroadcaster;
	}*/
	
	public function handleRequest(r:ConnectorRequest):Void {
		if(LocalRequest(r).getMethod()){
			loc.send(connId,LocalRequest(r).getMethod(),LocalRequest(r).getParam());
		}
		else{
			loc.connect(connId);
		}
	}
}