import org.as2lib.basic.event.EventInfo;
import org.as2lib.basic.TypedArray;

/**
 * @version 1.0
 */
interface org.as2lib.basic.event.EventDispatcher {
	/**
	 * Dispatches the event on all listeners with the help of the EventInfo instance.
	 * @param info
	 * @param listeners
	 */
	public function dispatch(event:EventInfo, listeners:TypedArray):Void;
}