import org.as2lib.env.out.level.ErrorLevel;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.Out;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.env.out.level.WarningLevel extends ErrorLevel {
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function warning(message:String, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutWriteInfo(message, Out.WARNING);
		broadcaster.dispatch(event);
	}
}