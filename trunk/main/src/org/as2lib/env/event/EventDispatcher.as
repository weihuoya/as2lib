import org.as2lib.env.event.EventInfo;
import org.as2lib.core.BasicInterface;
import org.as2lib.env.event.ListenerArray;

/**
 * @version 1.0
 */
interface org.as2lib.env.event.EventDispatcher extends BasicInterface {
	/**
	 * Dispatches the event on all listeners with the help of the EventInfo instance.
	 * @param info
	 * @param listeners
	 */
	public function dispatch(event:EventInfo, listeners:ListenerArray):Void;
	
	public function dispatchConsumeable(event:EventInfo, listeners:ListenerArray):Void;
}