import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.MissingServerException;
import org.as2lib.data.io.conn.local.SyntacticallyIncorrectMethodCallException;

class org.as2lib.data.io.conn.local.ExtendedLocalConnection extends LocalConnection {
	private var host:String;
	
	public function connect(host:String) {
		if (!super.connect(host)) {
			throw new ReservedHostException("Connection with host [" + host + "] is already in use.", this, arguments);
		}
	}
	
	public function send(host:String, method:String, args:Array){
		this.host = host;
		if (!super.send.apply(this, [host, method].concat(args))) {
			throw new SyntacticallyIncorrectMethodCallException("Passed arguments [" + args + "] are out of size.", this, arguments);
		}
	}
	
	public function onStatus(info){
		if (info.level == "error") {
			throw new MissingServerException("Server with host name [" + host + "] does not exist.", this, arguments);
		}
	}
	
}