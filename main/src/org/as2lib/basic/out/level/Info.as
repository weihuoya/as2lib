import org.as2lib.basic.out.level.Warning;
import org.as2lib.basic.out.OutInfo;
import org.as2lib.basic.event.EventBroadcaster;
import org.as2lib.basic.event.EventInfo;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.Info extends Warning {
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function info(message:String, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutInfo("write", message);
		broadcaster.dispatch(event);
	}
}