import org.as2lib.basic.out.level.Debug;
import org.as2lib.basic.out.OutInfo;
import org.as2lib.basic.event.EventBroadcaster;
import org.as2lib.basic.event.EventInfo;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.All extends Debug {
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function log(message:String, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutInfo("write", message);
		broadcaster.dispatch(event);
	}
}