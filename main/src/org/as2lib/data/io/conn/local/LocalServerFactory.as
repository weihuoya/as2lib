import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.local.ServerFactory;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.io.conn.local.SimpleLocalServer;

class org.as2lib.data.io.conn.local.LocalServerFactory extends BasicClass implements ServerFactory {
	public function LocalServerFactory(Void) {
	}
	
	public function getServer(host:String):LocalServer {
		return (new SimpleLocalServer(host));
	}
}