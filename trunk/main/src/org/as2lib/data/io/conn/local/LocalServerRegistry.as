import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.local.LocalServer;

class org.as2lib.data.io.conn.local.LocalServerRegistry extends BasicClass {
	public function getServer(host:String):LocalServer {
		return new LocalServer();
	}
	
	public function contains(host:String):Boolean {
		return true;
	}
	public function putServer(host:String, server:LocalServer):Void {}
}