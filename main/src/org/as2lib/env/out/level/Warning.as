import org.as2lib.env.out.level.Error;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.Out;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 * @see org.as2lib.env.out.level.Error
 */
class org.as2lib.env.out.level.Warning extends Error {
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function warning(message:String, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutWriteInfo(message, Out.WARNING);
		broadcaster.dispatch(event);
	}
}