import org.as2lib.core.BasicInterface;
import org.as2lib.data.io.conn.ConnectionProxy;

interface org.as2lib.data.io.conn.Connection extends BasicInterface {
	public function getProxy(path:String):ConnectionProxy;
	public function open(Void):Void;
	public function close(Void):Void;
}