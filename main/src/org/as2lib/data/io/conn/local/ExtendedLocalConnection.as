import org.as2lib.core.BasicClass;
import org.as2lib.util.Call;
import org.as2lib.env.overload.Overload;
import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.MissingServerException;
import org.as2lib.data.io.conn.local.SyntacticallyIncorrectMethodCallException;

class org.as2lib.data.io.conn.local.ExtendedLocalConnection extends BasicClass {
	private var host:String;
	private var connection:LocalConnection;
	private var target:Object;
	
	// sollte eigentlich keine Instanzvariable sein
	private var responseServer;
	
	public function ExtendedLocalConnection() {
		var o:Overload = new Overload(this);
		o.addHandler([Object], ExtendedLocalConnectionWithTarget);
		o.addHandler([], ExtendedLocalConnectionWithoutTarget);
		o.forward(arguments);
	}
	
	public function ExtendedLocalConnectionWithTarget(target):Void {
		this.target = target;
		connection = new LocalConnection();
	}
	
	public function ExtendedLocalConnectionWithoutTarget(Void):Void {
		ExtendedLocalConnectionWithTarget(this);
	}
	
	public function connect(host:String):Void {
		if (!connection.connect.apply(target, [host])) {
			throw new ReservedHostException("Connection with host [" + host + "] is already in use.", this, arguments);
		}
	}
	
	public function send():Void {
		var o:Overload = new Overload(this);
		o.addHandler([String, String], sendWithoutArgsAndResponse);
		o.addHandler([String, String, Array], sendWithArgs);
		o.addHandler([String, String, Call], sendWithResponse);
		o.addHandler([String, String, Array, Call], sendWithArgsAndResponse);
		o.forward(arguments);
	}
	
	public function sendWithoutArgsAndResponse(host:String, method:String):Void {
		sendWithArgs(host, method, []);
	}
	
	public function sendWithArgs(host:String, method:String, args:Array):Void {
		this.host = host;
		if (!connection.send.apply(target, [host, method].concat(args))) {
			throw new SyntacticallyIncorrectMethodCallException("Passed arguments [" + args + "] are out of size.", this, arguments);
		}
	}
	
	public function sendWithResponse(host:String, method:String, call:Call):Void {
		sendWithArgsAndResponse(host, method, [], call);
	}
	
	public function sendWithArgsAndResponse(host:String, method:String, args:Array, call:Call):Void {
		// in Methode auslagern
		var responseServerString:String = host + "." + method + "_Return";
		
		// in "inner class" aulagern
		responseServer = new ExtendedLocalConnection();
		responseServer.call = call;
		responseServer.onResponse = function(response):Void {
			this.call.execute([response]);
			this.close();
		}
		responseServer.connect(responseServerString);

		args.push(responseServerString);
		
		sendWithArgs(host, method, args);
	}
	
	public function close(Void):Void {
		connection.close();
	}
	
	private function onStatus(info):Void {
		if (info.level == "error") {
			throw new MissingServerException("Server with host name [" + host + "] does not exist.", this, arguments);
		}
	}
}