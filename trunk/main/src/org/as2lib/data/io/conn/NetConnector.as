import org.as2lib.data.io.conn.Connector;
import org.as2lib.data.io.conn.ConnectionListener;
import org.as2lib.data.io.conn.ConnectionRequest;
import org.as2lib.data.io.conn.ResponseController;
//import org.as2lib.data.io.comm.remoting

class org.as2lib.data.io.conn.NetConnector implements Connector {
	private var gatewayUrl:String;
	private var responseCtrl:ResponseController;
	
	public function NetConnector(Void) {
		responseCtrl = new ResponseController();
	}
	
	public function initConnection(Void):Void {
		
		//TODO: ServiceLocator activation
	}
	public function getUrl(Void):String {
		return gatewayUrl
	}
	public function setUrl(aUrl:String):Void {
		gatewayUrl = aUrl;
	}
	
	public function addListener(l:ConnectionListener):Void {
		responseCtrl.addListener(l);
	}
	
	public function handleRequest(r:ConnectionRequest):Void {
		// TODO: Handle an Netconnection Request.
	}
}