import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectionFactory;
import org.as2lib.data.io.conn.Connection;

class org.as2lib.data.io.conn.local.LocalConnFactory extends BasicClass implements ConnectionFactory {
	public function getConnection(host:String, path:String):Connection{
		return new Connection();
	}
}