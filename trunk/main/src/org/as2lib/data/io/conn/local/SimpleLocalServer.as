import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.LocalConfig;

class org.as2lib.data.io.conn.local.SimpleLocalServer extends BasicClass implements LocalServer {
	private var host:String;
	private var serviceMap:HashMap;
	private var running:Boolean;
	
	public function SimpleLocalServer(host:String) {
		this.host = host;
		serviceMap = new HashMap();
		running = false;
	}
	
	public function run(Void):Void {
		var keys:Array = serviceMap.getKeys();
		var iterator:Iterator = serviceMap.iterator();
		while (iterator.hasNext()){
			var service:Object = iterator.next();
			var key:String = String(keys.shift());
			// source out: 'host + "/" + key'
			if (!service.connect(host + "/" + key)){
				throw new ReservedHostException("Connection with name [" + host + "/" + key + "] is already in use.", this, arguments);
			}
		}
		LocalConfig.getServerRegistry().register(this);
		running = true;
	}
	
	public function stop(Void):Void {
		LocalConfig.getServerRegistry().remove(this);
		running = false;
	}
	
	public function putService(service:String, object):Void {
		var adapter:Object = new Object();
		ObjectUtil.setAccessPermission(LocalConnection.prototype, null, ObjectUtil.ACCESS_PROTECT_OVERWRITE | ObjectUtil.ACCESS_PROTECT_DELETE);
		ObjectUtil.setAccessPermission(LocalConnection.prototype, ["__proto__", "constructor"], ObjectUtil.ACCESS_NOTHING_ALLOWED);
		var i:String;
		for (i in LocalConnection.prototype) {
			adapter[i] = LocalConnection.prototype[i];
		}
		adapter.__proto__ = object;
		serviceMap.put(service, adapter);
	}
	
	public function isRunning(Void):Boolean {
		return running;
	}
	
	public function getHost(Void):String {
		return host;
	}
}