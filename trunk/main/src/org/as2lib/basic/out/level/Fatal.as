import org.as2lib.basic.out.level.None;
import org.as2lib.basic.out.OutInfo;
import org.as2lib.basic.event.EventBroadcaster;
import org.as2lib.basic.event.EventInfo;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.Fatal extends None {
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function fatal(exception:Exception, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutInfo("write", "", exception);
		broadcaster.dispatch(event);
	}
}