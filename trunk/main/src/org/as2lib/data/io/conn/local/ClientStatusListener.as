import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.env.event.EventListener;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.OutAccess;
import org.as2lib.util.ObjectUtil;
import org.as2lib.Config;
import org.as2lib.data.io.conn.local.LocalServer;

class org.as2lib.data.io.conn.local.ClientStatusListener extends NetConnection implements EventListener {
	
	private var aOut:OutAccess;
	private var server:LocalServer;
	
	public function ClientStatusListener(server:LocalServer){
		aOut = Config.getOut();
		aOut.debug(getClass().getName()+" - Constructor:"+server.getClass().getName());
		this.server = server;
	}
	
	public function onStatus(infoObj){
		aOut.debug(getClass().getName()+".onStatus: "+infoObj.level);
		if(infoObj.level == "error") {
			aOut.debug("erro");
			//eventBroadcaster.dispatch(new ConnectorError(new MissingClientException("One client doesn´t exist anymore !",this,arguments)));
		}
		if(infoObj.level == "status") {
			aOut.debug("status");
			//eventBroadcaster.dispatch(new ConnectorResponse("Broadcast to client was successful!"));
		}
	}
	
	/**
	 * Uses the ReflectUtil#getClassInfo() operation to fulfill the task.
	 *
	 * @see org.as2lib.core.BasicInterface#getClass()
	 * @see org.as2lib.env.util.ReflectUtil;
	 */
	public function getClass(Void):ClassInfo {
		return ReflectUtil.getClassInfo(this);
	}
	
	/**
	 * Returns a String representation of the instance. The String representation
	 * is obtained via the Stringifier obtained from the ObjectUtil#getStringifier()
	 * operation.
	 *
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return ObjectUtil.getStringifier().execute(this);
	}
}