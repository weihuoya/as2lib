import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.Connection;
import org.as2lib.data.io.conn.ConnectionProxy;
import org.as2lib.data.io.conn.local.LocalConnProxy;
import org.as2lib.data.io.conn.local.LocalConfig;
import org.as2lib.data.io.conn.local.ReservedHostException;

class org.as2lib.data.io.conn.local.LocalConn extends BasicClass implements Connection {
	private var host:String;
	private var opened:Boolean;
	
	public function LocalConn(host:String) {
		this.host = host;
		opened = false;
	}
	
	public function getProxy(path:String):ConnectionProxy {
		if (opened) {
			return (new LocalConnProxy(host + "/" + path));
		}
	}
	
	public function open(Void):Void {
		if (!LocalConfig.getServerRegistry().contains(host)) {
			throw new ReservedHostException("The server with host [" + host + "] is not available.",
											this,
											arguments);
		}
		opened = true;
	}
	
	public function close(Void):Void {
		opened = false;
	}
}