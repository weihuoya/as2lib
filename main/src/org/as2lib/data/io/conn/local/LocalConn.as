import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.Connection;
import org.as2lib.data.io.conn.ConnectionProxy;
import org.as2lib.data.io.conn.local.LocalConnProxy;

class org.as2lib.data.io.conn.local.LocalConn extends BasicClass implements Connection {
	private var host:String;
	private var connection:LocalConnection;
	
	public function LocalConn(host:String) {
		this.host = host;
		// move into open()
		connection = new LocalConnection();
	}
	
	public function getProxy(path:String):ConnectionProxy {
		return (new LocalConnProxy(host + "/" + path, connection));
	}
	
	public function open(Void):Void {
		
	}
	
	public function close(Void):Void {
		
	}
}