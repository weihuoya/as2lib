import org.as2lib.core.BasicInterface;

interface org.as2lib.data.io.conn.ConnectorRequest extends BasicInterface {
	public function setService(service:String):Void;
	public function getRequestObject(Void):Object;
}