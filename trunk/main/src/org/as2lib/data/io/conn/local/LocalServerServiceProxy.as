import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.local.MissingReceiverException;
import org.as2lib.data.io.conn.local.OutOfParameterLimitException;

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
				throw new OutOfParameterLimitException("Response values of remote method: '"+method+"' are oversized.",this,arguments);
			}
		}
	}
	
	public function onStatus(info){
		if(info.level == "error") {
			throw new MissingReceiverException("Receiver for response of remote method: '"+method+"' doesn´t exist anymore !",this,arguments);
		}
		if(info.level == "status") {
			trace("Response of remote method: '"+method+"' to receiver was successful!");
		}
	}
}