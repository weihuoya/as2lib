import org.as2lib.core.BasicClass;
import org.as2lib.data.iterator.Iterator;
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
		var iterator:Iterator = pathMap.iterator();
		while (iterator.hasNext()){
			var path = iterator.next();
			var key:String = String(keys.shift());
			if (!rObj.connect(key)){
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
		mixIn.__proto__ = object;
		pathMap.put(path, mixIn);
	}
}