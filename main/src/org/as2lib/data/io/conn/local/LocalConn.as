import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.data.io.conn.Connection;
import org.as2lib.data.io.conn.ServiceProxy;
import org.as2lib.data.io.conn.local.LocalClientServiceProxy;
import org.as2lib.data.io.conn.local.LocalConfig;
import org.as2lib.data.io.conn.local.MissingServerException;
import org.as2lib.data.io.conn.local.MissingServiceException;

class org.as2lib.data.io.conn.local.LocalConn extends BasicClass implements Connection {
	private var host:String;
	private var opened:Boolean;
	
	public function LocalConn(host:String) {
		this.host = host;
		opened = false;
	}
	
	public function getProxy(service:String):ServiceProxy {
		if (opened) {
			var lc:LocalConnection = new LocalConnection();
			if (lc.connect(host + "/" + service)) {
				throw new MissingServiceException("The service [" + service + "] on host [" + host + "] does not exist.", this, arguments);
			}
			return (new LocalClientServiceProxy(host + "/" + service));
		}
		throw new IllegalStateException("You must call the #open() operation before calling #getProxy().", this, arguments);
	}
	
	public function open(Void):Void {
		if (!LocalConfig.getServerRegistry().contains(host)) {
			throw new MissingServerException("The server with host [" + host + "] is not available.", this, arguments);
		}
		opened = true;
	}
	
	public function close(Void):Void {
		opened = false;
	}
}