import org.as2lib.env.out.level.FatalLevel;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.out.Out;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 * @see org.as2lib.env.out.level.FatalLevel
 */
class org.as2lib.env.out.level.ErrorLevel extends FatalLevel {
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function error(throwable:Throwable, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutErrorInfo(throwable, Out.ERROR);
		broadcaster.dispatch(event);
	}
}