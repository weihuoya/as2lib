import org.as2lib.core.BasicInterface;
import org.as2lib.data.io.conn.local.LocalServer;

interface org.as2lib.data.io.conn.local.ServerRegistry extends BasicInterface {
	public function getServer(host:String):LocalServer;
	public function containsServer(host:String):Boolean;
	public function putServer(host:String, server:LocalServer):Void;
	public function removeServer(host:String):Void;
}