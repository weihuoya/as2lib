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
	private var serviceArray:Array;
	private var running:Boolean;
	
	public function SimpleLocalServer(host:String) {
		this.host = host;
		serviceArray = new Array();
		running = false;
	}
	
	public function run(Void):Void {
		for (var i:Number = 0; i < serviceArray.length; i++) {
			LocalServerServiceProxy(serviceArray[i]).run();
		}
		LocalConfig.getServerRegistry().register(this);
		running = true;
	}
	
	public function stop(Void):Void {
		for (var i:Number = 0; i < serviceArray.length; i++) {
			LocalServerServiceProxy(serviceArray[i]).stop();
		}
		LocalConfig.getServerRegistry().remove(this);
		running = false;
	}
	
	public function putService(name:String, service):Void {
		serviceArray.push(new LocalServerServiceProxy(service, name, host));
	}
	
	public function isRunning(Void):Boolean {
		return running;
	}
	
	public function getHost(Void):String {
		return host;
	}
}