﻿import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;
import org.as2lib.data.io.conn.ServiceProxy;
import org.as2lib.util.Call;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.io.conn.local.ReservedHostException;
import org.as2lib.data.io.conn.local.ExtendedLocalConnection;

class org.as2lib.data.io.conn.local.LocalClientServiceProxy extends BasicClass implements ServiceProxy {
	private var target:String;
	private var connection:ExtendedLocalConnection;
	private var listenerMap:Map;
	
	public function LocalClientServiceProxy(target:String) {
		this.target = target;
		connection = new ExtendedLocalConnection();
		listenerMap = new HashMap();
	}
	
	public function putListener(method:String, call:Call):Void {
		listenerMap.put(method, call);
	}
	
	public function invoke():Void {
		var o:Overload = new Overload(this);
		o.addHandler([String, Array], invokeWithArgs);
		o.addHandler([String], invokeWithoutArgs);
		o.forward(arguments);
	}
	
	public function invokeWithArgs(method:String, args:Array):Void {
		if (listenerMap.containsKey(method)) {
			connection.send(target, "remoteCall", [method, args], listenerMap.get(method));
			return;
		}
		connection.send(target, "remoteCall", [method, args]);
	}
	
	public function invokeWithoutArgs(method:String):Void {
		invokeWithArgs(method, []);
	}
}