import org.as2lib.event.EventInfo;
import org.as2lib.basic.BasicInterface;
import org.as2lib.event.ListenerArray;

/**
 * @version 1.0
 */
interface org.as2lib.event.EventDispatcher extends BasicInterface {
	/**
	 * Dispatches the event on all listeners with the help of the EventInfo instance.
	 * @param info
	 * @param listeners
	 */
	public function dispatch(event:EventInfo, listeners:ListenerArray):Void;
	
	public function dispatchConsumeable(event:EventInfo, listeners:ListenerArray):Void;
}