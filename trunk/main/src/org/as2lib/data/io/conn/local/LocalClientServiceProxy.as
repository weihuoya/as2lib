import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ServiceProxy;
import org.as2lib.util.Call;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.LocalClientServiceStatusListener;

class org.as2lib.data.io.conn.local.LocalClientServiceProxy extends BasicClass implements ServiceProxy {
	private var target:String;
	private var connection:LocalConnection;
	private var listenerMap:Map;
	
	// wenn nicht Instanzvariable gehts nicht. Komische Sache!
	private var responseServer;
	
	public function LocalClientServiceProxy(target:String) {
		this.target = target;
		connection = new LocalConnection();
		listenerMap = new HashMap();
	}
	
	public function putListener(method:String, call:Call):Void {
		listenerMap.put(method, call);
	}
	
	public function invoke(method:String, args:Array):Void {
		if (listenerMap.containsKey(method)) {
			responseServer = new LocalConnection();
			responseServer.listener = listenerMap.get(method);
			responseServer.onResponse = function(response):Void {
				this.listener.execute([response]);
				this.close();
			}
			if(!responseServer.connect(target + "." + method + "_Return")) {
				throw new ReservedHostException("Connection with name [" + target + "." + method + "_Return] is already in use.", this, arguments);
			}
			var statusListener:LocalClientServiceStatusListener = new LocalClientServiceStatusListener(target,method);
			connection.send.apply(statusListener,[target,"remoteCall", method, args, (target + "." + method + "_Return")]);
			//connection.onStatus = function(info){trace("onStatus:"+info.level)}
			//connection.send(target, "remoteCall", method, args, (target + "." + method + "_Return"));
			return;
		}
		connection.send(target, "remoteCall", method, args);
	}
}