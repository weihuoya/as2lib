import org.as2lib.data.io.conn.ConnectionListener;
import org.as2lib.data.io.conn.ConnectionError;
import org.as2lib.data.io.conn.ConnectionResponse;
import org.as2lib.env.event.EventBroadcaster;

class org.as2lib.data.io.conn.ResponseController {
	private var eventBroadcaster:EventBroadcaster;
	
	public function ResponseController(){
		eventBroadcaster = new EventBroadcaster();
	}
	
	public function addListener(l:ConnectionListener):Void {
		eventBroadcaster.addListener(l);
	}
	
	public function sendError(){
		eventBroadcaster.dispatch();
	}
	
	public function sendResponse(){}

}