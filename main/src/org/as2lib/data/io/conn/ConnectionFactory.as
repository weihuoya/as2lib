import org.as2lib.core.BasicInterface;
import org.as2lib.data.io.conn.Connection;

interface org.as2lib.data.io.conn.ConnectionFactory extends BasicInterface{
	public function getConnection(host:String, path:String):Connection;
}