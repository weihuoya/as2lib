import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventDispatcher;

/**
 * Special form of EventBroadcaster that delegates dispatch to a EventDispatcher.
 * You can define a dispatcher for the dispatch method. In this way it is possible
 * to define in a free way how you want to dispatch a event.
 * 
 * @see EventBroadcaster
 * @autor Martin Heidegger
 */
interface org.as2lib.env.event.DelegatingEventBroadcaster extends EventBroadcaster {
	/**
	 * Sets the EventDispatcher to delegate to.
	 * 
	 * @param eventDispatcher Dispatcher instance to delegate to.
	 */
	public function setDispatcher(eventDispatcher:EventDispatcher):Void;
}