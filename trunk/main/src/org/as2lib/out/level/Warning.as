import org.as2lib.out.level.Error;
import org.as2lib.out.info.OutWriteInfo;
import org.as2lib.event.EventBroadcaster;
import org.as2lib.event.EventInfo;
import org.as2lib.out.Out;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.out.level.Warning extends Error {
	/**
	 * @see org.as2lib.out.OutLevel
	 */
	public function warning(message:String, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutWriteInfo("write", message, Out.WARNING);
		broadcaster.dispatch(event);
	}
}