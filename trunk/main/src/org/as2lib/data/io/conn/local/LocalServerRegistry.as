import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.local.LocalServer;

interface org.as2lib.data.io.conn.local.LocalServerRegistry extends BasicClass{
	public function getServer(host:String):LocalServer{}
	public function contains(host:String):Boolean{}
	public function putServer(host:String, server:LocalServer):Void{}
}