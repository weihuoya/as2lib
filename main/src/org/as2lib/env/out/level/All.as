import org.as2lib.env.out.level.Debug;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.Out;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 * @see org.as2lib.env.out.level.
 */
class org.as2lib.env.out.level.All extends Debug {
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function log(message:String, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutWriteInfo(message, Out.ALL);
		broadcaster.dispatch(event);
	}
}