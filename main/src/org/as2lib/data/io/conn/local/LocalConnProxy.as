import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectionProxy;

class org.as2lib.data.io.conn.local.LocalConnProxy extends BasicClass implements ConnectionProxy {
	private var target:String;
	private var connection:LocalConnection;
	private var responseFlag:Boolean;
	
	public function LocalConnProxy(target:String) {
		this.target = target;
		this.connection = new LocalConnection();
		this.responseFlag = true;
	}
	
	public function __resolve(methodName:String):Function {
		var result:Function = function() {
			
			var args:Array = [target, methodName].push(arguments);
			connection.send.apply(connection, args);
			
			var lc:LocalConnection = new LocalConnection();
			lc.onResponse = function(response){
				this.response = response;
				responseFlag = false;
			}
			var o:Object = new Object();
			lc.connect.apply(this,host+"/"+methodName+"_Return");
			
			while(responseFlag){}
		}
		return lc.response;
	}
}