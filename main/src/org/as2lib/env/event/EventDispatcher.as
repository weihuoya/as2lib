import org.as2lib.core.BasicInterface;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.ListenerArray;

/**
 * EventDispatchers are used to dispatch to EventListeners.
 * Implement the EventDispatcher for different ways to dispatch events.
 * It is possible to add an EventDispatcher instance to a DelegatingEventBroadcaster.
 * 
 * @see org.as2lib.env.event.DelegatingEventBroadcaster#setEventDispatcher
 * @author Simon Wacker
 * @author Martin Heidegger
 */
interface org.as2lib.env.event.EventDispatcher extends BasicInterface {
	/**
	 * Dispatches the event to all EventListeners with the help of the EventInfo instance.
	 *
	 * @param info the EventInfo to be passed to the event
	 * @param listeners the EventListeners to dispatch to
	 */
	public function dispatch(event:EventInfo, listeners:ListenerArray):Void;
	
	/**
	 * Dispatches the event to all EventListeners with the help of the EventInfo instance.
	 * Special about this operation is that it will be checked whether the EventInfo
	 * is consumed. If it is consumed the dispatching will abruptly stop.
	 *
	 * @param info the EventInfo to be passed to the event
	 * @param listeners the EventListeners to dispatch to
	 */
	public function dispatchConsumeable(event:EventInfo, listeners:ListenerArray):Void;
}