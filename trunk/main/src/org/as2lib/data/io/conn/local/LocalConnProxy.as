import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectionProxy;

class org.as2lib.data.io.conn.local.LocalConnProxy extends BasicClass implements ConnectionProxy {
	private var target:String;
	private var connection:LocalConnection;
	
	public function LocalConnProxy(target:String, connection:LocalConnection) {
		this.target = target;
		this.connection = connection;
	}
	
	public function __resolve(methodName:String):Function {
		var result:Function = function() {
			// Flash is interesting. Where the heck are these vars coming from?
			// Are the flying free in the room and you can reach them even
			// after the method execution has finished and the function
			// is in nowheres scope?
			/*var target:String = String(arguments.callee.target);
			var connection:LocalConnection = LocalConnection(arguments.callee.connection);
			var method:String = String(arguments.callee.method);*/
			var args:Array = [target, methodName].concat(arguments);
			connection.send.apply(connection, args);
		}
		/*result.target = target;
		result.connection = connection;
		result.method = methodName;*/
		return result;
	}
}