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
		var overload:Overload = new Overload(this);
		overload.addHandler([String, String, Array], sendWithoutResponse);
		overload.addHandler([String, String, Array, Call], sendWithResponse);
		overload.forward(arguments);
	}
	
	public function sendWithoutResponse(host:String, method:String, args:Array):Void {
		this.host = host;
		if (!super.send.apply(this, [host, method].concat(args))) {
			throw new SyntacticallyIncorrectMethodCallException("Passed arguments [" + args + "] are out of size.", this, arguments);
		}
	}
	
	public function sendWithResponse(host:String, method:String, args:Array, call:Call):Void {
		this.host = host;
		
		var responseServerString:String = host + "." + args[0] + "_Return";

		responseServer = new ExtendedLocalConnection();
		responseServer.call = call;
		responseServer.onResponse = function(response):Void {
			this.call.execute([response]);
			this.close();
		}
		responseServer.connect(responseServerString);

		var args:Array = [host, method].concat(args);
		args.push(responseServerString);
		
		if (!super.send.apply(this, args)) {
			throw new SyntacticallyIncorrectMethodCallException("Passed arguments [" + args + "] are out of size.", this, arguments);
		}
	}
	
	private function onStatus(info):Void {
		if (info.level == "error") {
			throw new MissingServerException("Server with host name [" + host + "] does not exist.", this, arguments);
		}
	}
}