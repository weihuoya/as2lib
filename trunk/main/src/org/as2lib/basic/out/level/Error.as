import org.as2lib.basic.out.level.Fatal;
import org.as2lib.basic.out.OutInfo;
import org.as2lib.basic.event.EventBroadcaster;
import org.as2lib.basic.event.EventInfo;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.Error extends Fatal {
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function error(exception:Exception, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutInfo("write", "", exception);
		broadcaster.dispatch(event);
	}
}