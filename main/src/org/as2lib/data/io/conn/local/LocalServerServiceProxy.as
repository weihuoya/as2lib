import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.local.MissingServerException;
import org.as2lib.data.io.conn.local.SyntacticallyIncorrectMethodCallException;

class org.as2lib.data.io.conn.local.LocalServerServiceProxy extends LocalConnection {
	private var service;
	private var method:String;
	
	public function LocalServerServiceProxy(service) {
		this.service = service;
	}
	
	public function remoteCall(method:String, args:Array, listener:String):Void {
		var response = service[method].apply(service, args);
		this.method = method;
		// Fehler abfangen und noch einmal probieren? oder Exception?
		if (listener) {
			if(!send(listener, "onResponse", response)) {
				throw new SyntacticallyIncorrectMethodCallException("Response values of remote method: '"+method+"' are oversized.",this,arguments);
			}
		}
	}
	
	public function onStatus(info){
		if(info.level == "error") {
			throw new MissingServerException("No receiver with connection to call method '"+method+"' existing !",this,arguments);
		}
		if(info.level == "status") {
			trace("Call to remote method '"+method+"' was successful!");
		}
	}
}