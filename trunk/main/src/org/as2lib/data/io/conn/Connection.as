import org.as2lib.core.BasicInterface;
import org.as2lib.data.io.conn.ServiceProxy;

interface org.as2lib.data.io.conn.Connection extends BasicInterface {
	public function getProxy(service:String):ServiceProxy;
	public function open(Void):Void;
	public function close(Void):Void;
}