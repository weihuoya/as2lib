import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectionProxy;

class org.as2lib.data.io.conn.local.LocalConnProxy extends BasicClass implements ConnectionProxy {
	private var target:String;
	
	public function LocalConnProxy(target:String) {
		this.target = target;
	}
	
	public function __resolve(methodName:String):Function {
		var connection:LocalConnection = new LocalConnection();
		var result:Function = function() {
			var args:Array = [target, methodName].concat(arguments);
			connection.send.apply(connection, args);
		}
		return result;
	}
}