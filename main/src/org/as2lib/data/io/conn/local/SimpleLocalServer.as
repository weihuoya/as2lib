import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.HashMap;
import org.as2lib.data.io.conn.local.ReservedHostException;

class org.as2lib.data.io.conn.local.SimpleLocalServer extends BasicClass {
	
	private var conn:LocalConnection;
	private var host:String;
	private var pathMap:HashMap;
	
	public function SimpleLocalServer(host:String) {
		
		this.host = host;
		conn = new LocalConnection();
		pathMap = new HashMap();
	}
	
	public function run(Void):Void {
		
		if(!conn.connect(host)){
			throw new ReservedHostException("Connection name "+host+" is already used by another LocalConnection",this,arguments);
		}
	}
	public function putPath(path:String, object):Void {
		pathMap.put(path,object);
	}
}