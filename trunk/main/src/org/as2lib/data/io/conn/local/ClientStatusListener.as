import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.env.event.EventListener;
import org.as2lib.core.BasicClass;
import org.as2lib.env.out.OutAccess;
import org.as2lib.Config;
import org.as2lib.data.io.conn.local.LocalServer;

class org.as2lib.data.io.conn.local.ClientStatusListener extends BasicClass implements EventListener {
	
	private var aOut:OutAccess;
	private var server:LocalServer;
	private var connID:String;
	
	public function ClientStatusListener(server:LocalServer, connID:String){
		aOut = Config.getOut();
		aOut.debug(getClass().getName()+" - Constructor:"+server.getClass().getName());
		this.server = server;
		this.connID = connID;
	}
	
	public function onStatus(infoObj){
		aOut.debug(getClass().getName()+".onStatus: "+infoObj.level);
		server.statusDispatch(infoObj,connID);
	}
}