import org.as2lib.data.io.conn.ConnectionListener;
import org.as2lib.data.io.conn.ConnectionRequest;

interface org.as2lib.data.io.conn.Connector {
	public function initConnection(Void):Void;
	public function getUrl(Void):String;
	public function setUrl(path:String):Void;
	public function addListener(listener:ConnectionListener):Void;
	public function handleRequest(request:ConnectionRequest):Void;
}