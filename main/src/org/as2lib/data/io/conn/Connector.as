import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorRequest;
import org.as2lib.core.BasicInterface;

interface org.as2lib.data.io.conn.Connector extends BasicInterface {
	public function initConnection(Void):Void;
	public function getHost(Void):String;
	public function setHost(host:String):Void;
	public function getPath(Void):String;
	public function setPath(path:String):Void;
	public function getMethod(Void):String;
	public function setMethod(method:String):Void;
	public function getParams();
	public function setParams():Void;
	public function addListener(listener:ConnectorListener):Void;
	public function removeListener(listener:ConnectorListener):Void;
	public function handleRequest(request:ConnectorRequest):Void;
}