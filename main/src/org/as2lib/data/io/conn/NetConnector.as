import org.as2lib.data.io.conn.Connector;
import org.as2lib.data.io.conn.ConnectionListener;
import org.as2lib.data.io.conn.ConnectionRequest;
import org.as2lib.data.io.comm.remoting
import org.as2lib.env.event.EventBroadcaster;

class org.as2lib.data.io.conn.NetConnector implements Connector {
	private var eventBroadcaster:EventBroadcaster;
	
	public function NetConnector(Void) {
		eventBroadcaster = new EventBroadcaster();
	}
	
	public function initConnection(Void):Void {
		
	}
	public function getUrl(Void):String {}
	public function setUrl(path:String):Void {}
	
	public function addListener(l:ConnectionListener):Void {
		eventBroadcaster.addListener(l);
	}
	
	public function handleRequest(r:ConnectionRequest):Void {
		// TODO: Handle an Netconnection Request.
	}
}