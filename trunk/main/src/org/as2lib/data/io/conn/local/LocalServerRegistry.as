import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.local.ServerRegistry;
import org.as2lib.data.io.conn.local.SimpleLocalServer;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.holder.HashMap;

class org.as2lib.data.io.conn.local.LocalServerRegistry extends BasicClass implements ServerRegistry {
	
	private var serverMap:HashMap;
	
	public function LocalServerRegistry(Void) {
		serverMap = new HashMap();
	}
		
	public function getServer(host:String):LocalServer {
		if(serverMap.containsKey(host)) {
			return serverMap.get(host);
		}
		else {
			return new SimpleLocalServer(host);
		}
	}
	
	public function contains(host:String):Boolean {
		return serverMap.containsKey(host);
	}
	public function putServer(host:String, server:LocalServer):Void {
		serverMap.put(host,server);
	}
}