import org.as2lib.core.BasicClass;
import org.as2lib.core.BasicInterface;

class org.as2lib.data.io.conn.ConnectorRequest extends BasicClass implements BasicInterface {
	private var host:String;
	private var path:String;
	private var method:String;
	private var args:Array;
	
	public function ConnectorRequest(host:String, path:String, method:String) {
		if(host != "" || host != null) this.host = host;
		if(path != "" || path != null) this.path = path;
		if(method != "" || method != null){
			this.method = method;
			this.args = new Array();
			for(var i=3; i<arguments.length; i++) {
				args.push(arguments[i]);
			}
		}
	}
	
	public function setHost(host:String):Void {
		this.host = host;
	}
	
	public function getHost(Void):String {
		return host;
	}
	
	public function setPath(path:String):Void {
		this.path = path;
	}
	
	public function getPath(Void):String {
		return path;
	}
	
	public function setMethod(method:String):Void {
		this.method = method;
	}
	
	public function getMethod(Void):String {
		return method;
	}
	
	public function setParams():Void {
		args = arguments;
	}
	
	public function getParams():Array {
		return args;
	}
}