import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.local.MissingServerException;
import org.as2lib.data.io.conn.local.SyntacticallyIncorrectMethodCallException;
import org.as2lib.data.io.conn.local.ExtendedLocalConnection;
import org.as2lib.env.overload.Overload;

class org.as2lib.data.io.conn.local.LocalServerServiceProxy extends ExtendedLocalConnection {
	private var service;
	
	public function LocalServerServiceProxy(service) {
		this.service = service;
	}
	
	public function remoteCall() {
		var overload:Overload = new Overload(this);
		overload.addHandler([String, Array, String],remoteCallwithResponse);
		overload.addHandler([String, Array],remoteCallwithoutResponse);
		overload.forward(arguments);
	}
	
	public function remoteCallwithResponse(method:String, args: Array, listener:String):Void {
		var response = service[method].apply(service, args);
		send(listener, "onResponse", [response]);
	}
	
	public function remoteCallwithoutResponse(method:String, args:Array):Void {
		service[method].apply(service, args);
	}
}