import org.as2lib.core.BasicInterface;
import org.as2lib.data.io.conn.local.LocalServer;

interface org.as2lib.data.io.conn.local.ServerRegistry extends BasicInterface {
	public function contains(host:String):Boolean;
	public function register(server:LocalServer):Void;
	public function remove(server:LocalServer):Void;
}