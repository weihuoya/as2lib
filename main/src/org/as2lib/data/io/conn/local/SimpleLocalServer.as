import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.LocalConfig;

class org.as2lib.data.io.conn.local.SimpleLocalServer extends BasicClass implements LocalServer {
	private var host:String;
	private var pathMap:HashMap;
	private var running:Boolean;
	
	public function SimpleLocalServer(host:String) {
		this.host = host;
		pathMap = new HashMap();
		running = false;
	}
	
	public function run(Void):Void {
		var keys:Array = pathMap.getKeys();
		var iterator:Iterator = pathMap.iterator();
		while (iterator.hasNext()){
			var path:Object = iterator.next();
			var key:String = String(keys.shift());
			// source out: 'host + "/" + key'
			if (!path.connect(host + "/" + key)){
				throw new ReservedHostException("Connection name [" + host + "/" + key + "] is already in use.", this, arguments);
			}
		}
		LocalConfig.getServerRegistry().register(host);
		running = true;
	}
	
	public function isRunning(Void):Boolean {
		return running;
	}
	
	public function putPath(path:String, object):Void {
		var localConnection:Object = new Object();
		ObjectUtil.setAccessPermission(LocalConnection.prototype, null, ObjectUtil.ACCESS_PROTECT_OVERWRITE | ObjectUtil.ACCESS_PROTECT_DELETE);
		ObjectUtil.setAccessPermission(LocalConnection.prototype, ["__proto__", "constructor"], ObjectUtil.ACCESS_NOTHING_ALLOWED);
		var i:String;
		for (i in LocalConnection.prototype) {
			localConnection[i] = LocalConnection.prototype[i];
		}
		localConnection.__proto__ = object;
		pathMap.put(path, localConnection);
	}
}