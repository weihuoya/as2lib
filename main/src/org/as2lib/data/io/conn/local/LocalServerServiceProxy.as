import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.local.MissingServerException;
import org.as2lib.data.io.conn.local.SyntacticallyIncorrectMethodCallException;
import org.as2lib.data.io.conn.local.ExtendedLocalConnection;
import org.as2lib.env.overload.Overload;

class org.as2lib.data.io.conn.local.LocalServerServiceProxy extends BasicClass {
	private var service;
	private var name:String;
	private var host:String;
	private var connection:ExtendedLocalConnection;
	
	public function LocalServerServiceProxy(service, name:String, host:String) {
		this.service = service;
		this.name = name;
		this.host = host;
		connection = new ExtendedLocalConnection(this);
	}
	
	public function run(Void):Void {
		// source out: 'host + "/" + key'
		connection.connect(host + "/" + name);
	}
	
	public function stop(Void):Void {
		connection.close();
	}
	
	public function remoteCall() {
		var o:Overload = new Overload(this);
		o.addHandler([String, Array, String], remoteCallWithResponse);
		o.addHandler([String, Array], remoteCallWithoutResponse);
		o.forward(arguments);
	}
	
	public function remoteCallWithResponse(method:String, args:Array, listener:String):Void {
		var response = service[method].apply(service, args);
		var lc:ExtendedLocalConnection = new ExtendedLocalConnection();
		lc.send(listener, "onResponse", [response]);
	}
	
	public function remoteCallWithoutResponse(method:String, args:Array):Void {
		service[method].apply(service, args);
	}
}