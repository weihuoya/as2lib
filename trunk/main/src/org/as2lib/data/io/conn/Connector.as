import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorRequest;

interface org.as2lib.data.io.conn.Connector {
	public function initConnection(Void):Void;
	public function getIdentifier(Void):String;
	public function setIdentifier(path:String):Void;
	public function addListener(listener:ConnectorListener):Void;
	public function removeListener(listener:ConnectorListener):Void;
	public function handleRequest(request:ConnectorRequest):Void;
}