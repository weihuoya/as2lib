import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.io.conn.local.ServerRegistry;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.io.conn.local.ReservedHostException;

class org.as2lib.data.io.conn.local.LocalServerRegistry extends BasicClass implements ServerRegistry {
	private var serverMap:HashMap;
	
	public function LocalServerRegistry(Void) {
		serverMap = new HashMap();
	}
	
	public function contains(host:String):Boolean {
		return !(new LocalConnection().connect(host));
	}
	
	public function register(server:LocalServer):Void {
		if (contains(server.getHost())) throw new ReservedHostException("Connection with host [" + server.getHost() + "] is already in use.", this, arguments);
		var lc = new LocalConnection();
		lc.connect(server.getHost());
		serverMap.put(server.getHost(), lc);
	}
	
	public function remove(server:LocalServer):Void {
		if(serverMap.containsKey(server.getHost())){
			var lc:LocalConnection = serverMap.get(server.getHost());
			lc.close();
			serverMap.remove(server.getHost());
		}
		// Exception werfen falls Server nicht vorhanden um Programmierer darauf hinzuweisen
	}
}