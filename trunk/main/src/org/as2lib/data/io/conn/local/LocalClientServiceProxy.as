import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ServiceProxy;

class org.as2lib.data.io.conn.local.LocalClientServiceProxy extends BasicClass implements ServiceProxy {
	private var target:String;
	private var connection:LocalConnection;
	
	public function LocalClientServiceProxy(target:String) {
		this.target = target;
		this.connection = new LocalConnection();
	}
	
	public function __resolve(methodName:String):Function {
		var result:Function = function() {
			connection["responseFlag"] = true;
			connection["onResponse"] = function(response) {
				trace("onResponse");
				this.response = response;
				this.responseFlag = false;
			}
			connection.connect(target + "." + methodName + "_Return");
			connection.send(target, "remoteCall", methodName, arguments, target + "." + methodName + "_Return");
			
			/*while (connection["responseFlag"]) {
			}*/
			for (var i:Number = 0; i < 1000; i++) {
				trace(i);
			}
			
			return connection["response"];
		}
		return result;
	}
}