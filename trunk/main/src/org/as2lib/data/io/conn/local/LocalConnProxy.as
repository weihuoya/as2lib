import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectionProxy;

class org.as2lib.data.io.conn.local.LocalConnProxy extends BasicClass implements ConnectionProxy {
	private var target:String;
	private var connection:LocalConnection;
	
	public function LocalConnProxy(target:String) {
		this.target = target;
		this.connection = new LocalConnection();
	}
	
	public function __resolve(methodName:String):Function {
		var result:Function = function() {
			var lc:LocalConnection = new LocalConnection();
			lc["responseFlag"] = true;
			lc["onResponse"] = function(response) {
				this.response = response;
				this.responseFlag = false;
			}
			var o:Object = new Object();
			lc.connect(target + "." + methodName + "_Return");
			
			var args:Array = [target, methodName];
			args.push(arguments);
			connection.send.apply(connection, args, target + "." + methodName + "_Return");
			
			/*while (lc["responseFlag"]) {
			}*/
			
			return lc["response"];
		}
		return result;
	}
}