import org.as2lib.util.Call;
import org.as2lib.env.overload.Overload;
import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.MissingServerException;
import org.as2lib.data.io.conn.local.SyntacticallyIncorrectMethodCallException;

class org.as2lib.data.io.conn.local.ExtendedLocalConnection extends LocalConnection {
	private var host:String;
	private var responseServer;
	
	public function connect(host:String):Void {
		if (!super.connect(host)) {
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
		if (!super.send.apply(this, [host, method].concat(args))) {
			throw new SyntacticallyIncorrectMethodCallException("Passed arguments [" + args + "] are out of size.", this, arguments);
		}
	}
	
	public function sendWithResponse(host:String, method:String, call:Call):Void {
		sendWithArgsAndResponse(host, method, [], call);
	}
	
	public function sendWithArgsAndResponse(host:String, method:String, args:Array, call:Call):Void {
		// args[0] stimmt nur in diesem ganz speziellen Fall!!!!!
		var responseServerString:String = host + "." + args[0] + "_Return";

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
	
	private function onStatus(info):Void {
		if (info.level == "error") {
			throw new MissingServerException("Server with host name [" + host + "] does not exist.", this, arguments);
		}
	}
}