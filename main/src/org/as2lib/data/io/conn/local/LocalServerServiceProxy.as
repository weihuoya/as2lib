import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.local.MissingServerException;
import org.as2lib.data.io.conn.local.SyntacticallyIncorrectMethodCallException;
import org.as2lib.data.io.conn.local.ExtendedLocalConnection;

class org.as2lib.data.io.conn.local.LocalServerServiceProxy extends ExtendedLocalConnection {
	private var service;
	
	public function LocalServerServiceProxy(service) {
		this.service = service;
	}
	
	public function remoteCall(method:String, args:Array, listener:String):Void {
		var response = service[method].apply(service, args);
		if (listener) {
			send(listener, "onResponse", [response]);
		}
	}
}