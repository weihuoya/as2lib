import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectorRequest;

class org.as2lib.data.io.conn.local.LocalRequest extends BasicClass implements ConnectorRequest {
	
	/* method which is called on receiver swf */
	private var method:String;
	
	/* all passed arguments to constructor */
	private var args;
	
	/* domain for security aspects */
	private var domain:String;
	
	private var isSender:Boolean = false;
	
	public function LocalRequest(domain:String,method:String) {
		this.method = method;
		this.domain = domain;
		args = arguments;
		
		if(args.length >= 2){
			isSender = true;
		}
	}
	
	public function getDomain(Void):String {
		return domain;
	}
	
	public function getMethod(Void):String {
		return method;
	}
	
	public function getArguments(Void){
		return args;
	}
	
	public function getRequestObject(Void):Object {
		return new Object();
	}
}