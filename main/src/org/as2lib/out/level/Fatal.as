import org.as2lib.out.level.None;
import org.as2lib.out.info.OutErrorInfo;
import org.as2lib.event.EventBroadcaster;
import org.as2lib.event.EventInfo;
import org.as2lib.except.Throwable;
import org.as2lib.out.Out;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.out.level.Fatal extends None {
	/**
	 * @see org.as2lib.out.OutLevel
	 */
	public function fatal(throwable:Throwable, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutErrorInfo("error", throwable, Out.FATAL);
		broadcaster.dispatch(event);
	}
}