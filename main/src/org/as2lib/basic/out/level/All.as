import org.as2lib.basic.out.level.Debug;
import org.as2lib.basic.out.info.OutWriteInfo;
import org.as2lib.basic.event.EventBroadcaster;
import org.as2lib.basic.event.EventInfo;
import org.as2lib.basic.Out;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.All extends Debug {
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function log(message:String, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutWriteInfo("write", message, Out.ALL);
		broadcaster.dispatch(event);
	}
}