import org.as2lib.core.BasicClass;
import org.as2lib.env.event.EventListener;
import org.as2lib.data.io.conn.local.MissingReceiverException;

class org.as2lib.data.io.conn.local.LocalClientServiceStatusListener {//extends BasicClass implements EventListener {
	
	private var target:String;
	private var method:String;
	
	public function LocalClientServiceStatusListener(target:String, method:String){
		this.target = target;
		this.method = method;
	}
	
	public function onStatus(info){
		if(info.level == "error") {
			throw new MissingReceiverException("No receiver with connection '"+target+"' to call method '"+method+"' existing !",this,arguments);
		}
		if(info.level == "status") {
			trace("Call to remote method '"+method+"' was successful!");
		}
	}
}