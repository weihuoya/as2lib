import org.as2lib.data.io.conn.Connector;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorRequest;
import org.as2lib.data.io.conn.remoting.RemotingRequest;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SimpleEventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.remoting.Wrapper;
//import org.as2lib.data.io.conn.remoting.ServiceLocator;

class org.as2lib.data.io.conn.remoting.RemotingConnector extends BasicClass implements Connector {
	
	private var gatewayUrl:String;
	private var eventBroadcaster:EventBroadcaster;
	//private var serviceLoc:ServiceLocator;
	
	public function RemotingConnector(Void) {
		eventBroadcaster = new SimpleEventBroadcaster();
		/* to load "NetServices.as" and "NetDebug.as" */
		Wrapper.getInstance();
		//serviceLoc = ServiceLocator.getInstance(gatewayUrl,this);
	}
	
	public function initConnection(Void):Void {
		NetServices.setGatewayUrl(gatewayUrl);
		//ServiceLocator.getServiceInstance(serviceId);
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
	
	public function onResult(data){
		eventBroadcaster.dispatch(new ConnectorResponse(data));
	}
	
	public function onStatus(info){
		eventBroadcaster.dispatch(new ConnectorError(info.description,this,arguments,true,false));
	}
	
	/*public function getEventBroadcaster(Void):EventBroadcaster {
		//trace("getEventBroadcaster");
		return eventBroadcaster;
	}*/
	
	public function handleRequest(r:ConnectorRequest):Void {
		var conn:NetConnection = NetServices.createGatewayConnection();
		conn.call(RemotingRequest(r).getPath(),this);
		//serviceLoc.addService(RemotingRequest(r).getName(),RemotingRequest(r).getPath());
		// TODO: Handle an Netconnection Request.
	}
}