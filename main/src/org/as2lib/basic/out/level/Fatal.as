import org.as2lib.basic.out.level.None;
import org.as2lib.basic.out.OutErrorInfo;
import org.as2lib.basic.event.EventBroadcaster;
import org.as2lib.basic.event.EventInfo;
import org.as2lib.basic.Throwable;
import org.as2lib.basic.Out;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.Fatal extends None {
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function fatal(throwable:Throwable, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutErrorInfo("error", throwable, Out.FATAL);
		broadcaster.dispatch(event);
	}
}