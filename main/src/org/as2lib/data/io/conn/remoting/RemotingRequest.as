import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectorRequest;

class org.as2lib.data.io.conn.remoting.RemotingRequest extends BasicClass implements ConnectorRequest {
	
	private var serviceName:String;
	private var servicePath:String;
	
	public function RemotingRequest( servicePath:String, serviceName:String){
		this.serviceName = serviceName;
		this.servicePath = servicePath;
	}
	
	public function getName(Void):String{
		return serviceName;
	}
	
	public function getPath(Void):String{
		return servicePath;
	}
	
	public function getRequestObject(Void):Object{
		return new Object();
	}
}