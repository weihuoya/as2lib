import org.as2lib.env.out.level.Fatal;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.out.Out;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.env.out.level.Error extends Fatal {
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function error(throwable:Throwable, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutErrorInfo(throwable, Out.ERROR);
		broadcaster.dispatch(event);
	}
}