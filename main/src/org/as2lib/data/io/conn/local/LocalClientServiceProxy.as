﻿import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ServiceProxy;
import org.as2lib.util.Call;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.HashMap;

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
			responseServer.connect(target + "." + method + "_Return");
<<<<<<< LocalClientServiceProxy.as
			//responseSever.connect.apply(responseServer,[target + "." + method + "_Return"]);
=======
			connection.send(target, "remoteCall", method, args, (target + "." + method + "_Return"));
			return;
>>>>>>> 1.4
		}
		connection.send(target, "remoteCall", method, args);
	}
}