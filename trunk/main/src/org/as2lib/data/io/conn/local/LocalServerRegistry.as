import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.io.conn.local.ServerRegistry;
import org.as2lib.data.io.conn.local.SimpleLocalServer;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.io.conn.local.ReservedHostException;

class org.as2lib.data.io.conn.local.LocalServerRegistry extends BasicClass implements ServerRegistry {

	private var serverMap:HashMap;
	
	public function LocalServerRegistry(Void) {
		serverMap = new HashMap();
	}
	
	public function contains(host:String):Boolean {
		var lc:LocalConnection = new LocalConnection();
		return !lc.connect(host);
	}
	
	public function register(host:String):Void {
		if(contains(host)) throw new ReservedHostException("Connection name [" + host + "] is already in use.", this, arguments);
		var lc = new LocalConnection();
		lc.connect(host);
		serverMap.put(host,lc);
	}
	
	public function remove(host:String):Void {
		if(serverMap.containsKey(host)){
			var lc:LocalConnection = serverMap.get(host);
			lc.close();
			serverMap.remove(host);
		}
		
	}
}