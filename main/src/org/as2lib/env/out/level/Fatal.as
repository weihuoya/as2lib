import org.as2lib.env.out.level.None;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.out.Out;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.env.out.level.Fatal extends None {
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function fatal(throwable:Throwable, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutErrorInfo("error", throwable, Out.FATAL);
		broadcaster.dispatch(event);
	}
}