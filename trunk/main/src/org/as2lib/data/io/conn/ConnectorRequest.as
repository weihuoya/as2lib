import org.as2lib.core.BasicClass;
import org.as2lib.core.BasicInterface;

class org.as2lib.data.io.conn.ConnectorRequest extends BasicClass implements BasicInterface {
	private var host:String;
	private var path:String;
	private var method:String;
	private var args:FunctionArguments;
	
	public function setHost(host:String):Void {
		this.host = host;
	}
	public function setPath(path:String):Void {
		this.path = path;
	}
	public function setMethod(method:String):Void {
		this.method = method;
	}
	public function setParams():Void {
		args = arguments;
	}
}