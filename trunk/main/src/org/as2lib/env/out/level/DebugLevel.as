import org.as2lib.env.out.level.InfoLevel;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.Out;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 * @see org.as2lib.env.out.level.InfoLevel
 */
class org.as2lib.env.out.level.DebugLevel extends InfoLevel {
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function debug(message:String, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutWriteInfo(message, Out.DEBUG);
		broadcaster.dispatch(event);
	}
}