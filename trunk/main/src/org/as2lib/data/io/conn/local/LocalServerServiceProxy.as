import org.as2lib.core.BasicClass;

class org.as2lib.data.io.conn.local.LocalServerServiceProxy extends LocalConnection {
	private var service;
	
	public function LocalServerServiceProxy(service) {
		this.service = service;
	}
	
	public function remoteCall(method:String, args:Array, listener:String):Void {
		trace("remoteCall");
		var response = service[method].apply(service, args);
		// Fehler abfangen und noch einmal probieren? oder Exception?
		send(listener, "onResponse", response);
	}
}