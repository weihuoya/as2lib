import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectionFactory;
import org.as2lib.data.io.conn.Connection;
import org.as2lib.data.io.conn.local.LocalConn;
import org.as2lib.data.io.conn.local.LocalConfig;

class org.as2lib.data.io.conn.local.LocalConnFactory extends BasicClass implements ConnectionFactory {
	public function LocalConnFactory(Void) {
	}
	
	public function getConnection(host:String):Connection {
		var result:Connection = new LocalConn(host);
		result.open();
		return result;
	}
}