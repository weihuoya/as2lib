import org.as2lib.core.BasicInterface;
import org.as2lib.data.io.conn.local.LocalServer;

interface org.as2lib.data.io.conn.local.ServerFactory extends BasicInterface {
	public function getServer(host:String):LocalServer;
}