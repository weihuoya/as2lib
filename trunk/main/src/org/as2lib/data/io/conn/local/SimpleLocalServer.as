import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.local.LocalServer;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.io.conn.local.ReservedHostException;

class org.as2lib.data.io.conn.local.SimpleLocalServer extends BasicClass implements LocalServer {
	
	private var host:String;
	private var pathMap:HashMap;
	
	public function SimpleLocalServer(host:String) {
		this.host = host;
		pathMap = new HashMap();
	}
	
	public function run(Void):Void {
		
		var keys:Array = pathMap.getKeys();
		var it = pathMap.iterator();
		
		while(it.hasNext()){
			var rObj = it.next();
			var key:String = String(keys.shift());
			if(!rObj.connect(key)){
				throw new ReservedHostException("Connection name "+key+" is already used by another LocalConnection",this,arguments);
			}
		}
	}
	
	public function putPath(path:String, object):Void {
		var mixIn:Object = new Object();
		mixIn.lc = new LocalConnection();
		mixIn.connect = function(key) {
			return this.lc.connect(key);
		}
		//trace(mixIn.__proto__);
		//trace(mixIn.__proto__.__proto__);
		mixIn.__proto__ = object.prototype;
		//object.__proto__ = mixIn.prototype;
		pathMap.put(path,mixIn);
	}
}