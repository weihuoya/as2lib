import org.as2lib.data.io.conn.Connector;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorRequest;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.core.BasicClass;

class org.as2lib.data.io.conn.remoting.RemotingConnector extends BasicClass implements Connector {
	private var gatewayUrl:String;
	private var eventBroadcaster:EventBroadcaster;
	
	public function RemotingConnector(Void) {
		eventBroadcaster = new EventBroadcaster();
	}
	
	public function initConnection(Void):Void {
		
		//TODO: ServiceLocator activation
	}
	public function getIdentifier(Void):String {
		return gatewayUrl;
	}
	public function setIdentifier(aUrl:String):Void {
		gatewayUrl = aUrl;
	}
	
	public function addListener(l:ConnectorListener):Void {
		//trace("addListener");
		eventBroadcaster.addListener(l);
	}
	
	public function removeListener(l:ConnectorListener):Void {
		//trace("removeListener");
		eventBroadcaster.removeListener(l);
	}
	
	public function getEventBroadcaster(Void):EventBroadcaster {
		//trace("getEventBroadcaster");
		return eventBroadcaster;
	}
	
	public function handleRequest(r:ConnectorRequest):Void {
		// TODO: Handle an Netconnection Request.
	}
}