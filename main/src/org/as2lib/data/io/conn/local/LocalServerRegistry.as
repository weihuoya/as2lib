import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.io.conn.local.ServerRegistry;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.ExtendedLocalConnection;

class org.as2lib.data.io.conn.local.LocalServerRegistry extends BasicClass implements ServerRegistry {
	private var serverMap:HashMap;
	
	public function LocalServerRegistry(Void) {
		serverMap = new HashMap();
	}
	
	public function contains(host:String):Boolean {
		return ExtendedLocalConnection.connectionExists(host);
	}
	
	public function register(server:LocalServer):Void {
		var lc = new ExtendedLocalConnection();
		try {
			lc.connect(server.getHost());
		} catch (e:org.as2lib.data.io.conn.local.ReservedConnectionException) {
			throw (new ReservedHostException("Connection with host [" + server.getHost() + "] is already in use.", this, arguments)).initCause(e);
		}
		serverMap.put(server.getHost(), lc);
	}
	
	public function remove(server:LocalServer):Void {
		if(serverMap.containsKey(server.getHost())){
			var lc:ExtendedLocalConnection = ExtendedLocalConnection(serverMap.get(server.getHost()));
			lc.close();
			serverMap.remove(server.getHost());
		}
		throw new IllegalArgumentException("You tried to remove a server [" + server + "] with host [" + server.getHost() + "] from the registry that has not been registered.",
										   this,
										   arguments);
	}
}