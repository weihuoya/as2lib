import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.MissingServerException;
import org.as2lib.data.io.conn.local.SyntacticallyIncorrectMethodCallException;

class org.as2lib.data.io.conn.local.ExtendedLocalConnection extends LocalConnection {
	
	private var connectionName:String;
	
	public function connect(connectionName:String) {
		
		if(!super.connect(connectionName)) {
			throw new ReservedHostException("Connection with name ["+connectionName+"] is already in use.", this, arguments);
		}
	}
	
	public function send(connectionName:String, methodName:String, args:Array){
		this.connectionName = connectionName;
		
		if(super.send.apply(this, [connectionName,methodName].concat(args))) {
			throw new SyntacticallyIncorrectMethodCallException("Passed arguments are out of size.",this,arguments);
		}
	}
	
	public function onStatus(info){
		
		if(info.level == "error") {
			throw new MissingServerException("No server with connection '"+connectionName+"' existing !",this,arguments);
		}
	}
	
}