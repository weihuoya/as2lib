import org.as2lib.core.BasicClass;

class org.as2lib.data.io.conn.local.ServiceAdapter extends BasicClass {
	
	private var adaptedObj;
	private var lc:LocalConnection;
	
	public function ServiceAdapter(adaptedObj, lc:LocalConnection) {
		this.adaptedObj = adaptedObj;
	}
	
	public function getLocalConnection(Void):LocalConnection {
		return lc;
	}
	
	public function __resolve(methodName:String):Function {
		trace("methodName");
		var result:Function = function(args:Array, server:String) {
			trace("result");
			var result = adaptedObj.super[methodName].apply(adaptedObj.super, args);
			var args:Array = new Array();
			args.push("onResponse");
			args.push(result);
			lc.send.apply(this,[server].concat(args));
		}
		return result;
	}
}