import org.as2lib.basic.out.level.Error;
import org.as2lib.basic.out.OutWriteInfo;
import org.as2lib.basic.event.EventBroadcaster;
import org.as2lib.basic.event.EventInfo;
import org.as2lib.basic.Out;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.Warning extends Error {
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function warning(message:String, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutWriteInfo("write", message, Out.WARNING);
		broadcaster.dispatch(event);
	}
}