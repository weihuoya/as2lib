import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectorRequest;

class org.as2lib.data.io.conn.local.LocalRequest extends BasicClass implements ConnectorRequest {
	
	private var method:String;
	private var param:Array;
	
	public function LocalRequest( method:String, param:Array){
		this.method = method;
		this.param = param;
	}
	
	public function getMethod(Void):String{
		return method;
	}
	
	public function getParam(Void):Array{
		return param;
	}
	
	public function getRequestObject(Void):Object{
		return new Object();
	}
}