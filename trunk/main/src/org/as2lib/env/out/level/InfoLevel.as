import org.as2lib.env.out.level.WarningLevel;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.Out;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 * @see org.as2lib.env.out.level.WarningLevel
 */
class org.as2lib.env.out.level.InfoLevel extends WarningLevel {
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function info(message:String, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutWriteInfo(message, Out.INFO);
		broadcaster.dispatch(event);
	}
}