import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.Connection;
import org.as2lib.data.io.conn.ConnectionProxy;

class org.as2lib.data.io.conn.local.LocalConn extends BasicClass implements Connection {
	public function getProxy(Void):ConnectionProxy {
		return new ConnectionProxy();
	}
	public function open(Void):Void {}
	public function close(Void):Void {}
}