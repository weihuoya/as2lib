import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.LocalConfig;
import org.as2lib.data.io.conn.local.LocalServerServiceProxy;

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
		var serviceIterator:Iterator = serviceMap.iterator();
		while (serviceIterator.hasNext()){
			var service:LocalServerServiceProxy = LocalServerServiceProxy(serviceIterator.next());
			service.run();
		}
		LocalConfig.getServerRegistry().register(this);
		running = true;
	}
	
	public function stop(Void):Void {
		var serviceIterator:Iterator = serviceMap.iterator();
		while (serviceIterator.hasNext()) {
			var service:LocalServerServiceProxy = LocalServerServiceProxy(serviceIterator.next());
			service.stop();
		}
		LocalConfig.getServerRegistry().remove(this);
		running = false;
	}
	
	public function putService(name:String, service):Void {
		var proxy:LocalServerServiceProxy = new LocalServerServiceProxy(service, name, host);
		serviceMap.put(name, proxy);
	}
	
	public function isRunning(Void):Boolean {
		return running;
	}
	
	public function getHost(Void):String {
		return host;
	}
}