import org.as2lib.env.event.EventDispatcher;
import org.as2lib.env.event.dispatcher.NormalEventDispatcher;
import org.as2lib.env.event.dispatcher.LogEventDispatcher;
import org.as2lib.env.event.EventListener;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.ListenerArray;
import org.as2lib.env.event.Consumeable;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.event.EventBroadcaster extends BasicClass {
	/** A reference to the NormalEventDispatcher. */
	public static var normalDispatcher:EventDispatcher = new NormalEventDispatcher();
	
	/** A reference to the LogEventDispatcher. */
	public static var logDispatcher:EventDispatcher = new LogEventDispatcher();
	
	/** Contains all registered listeners. */
	private var listeners:ListenerArray;
	
	/** The used EventDispatcher */
	private var dispatcher:EventDispatcher;
	
	/**
	 * Constructs a new EventBroadcaster instance.
	 */
	public function EventBroadcaster(Void) {
		dispatcher = normalDispatcher;
		listeners = new ListenerArray();
	}
	
	/**
	 * Sets a new dispatcher to be used by the dispatch method.
	 *
	 * @param dispatcher the new dispatcher to be used
	 */
	public function setDispatcher(newDispatcher:EventDispatcher):Void {
		dispatcher = newDispatcher;
	}
	
	/**
	 * Adds a new listener to the list of listeners.
	 *
	 * @param listener the new listener
	 */
	public function addListener(listener:EventListener):Void {
		listeners.push(listener);
	}
	
	/**
	 * Removes a listener from the list of listeners.
	 *
	 * @param listener the listener that shall be removed
	 */
	public function removeListener(listener:EventListener):Void {
		listeners.remove(listener);
	}
	
	/**
	 * Removes all registered listeners.
	 */
	public function removeAllListener(Void):Void {
		listeners.clear();
	}
	
	/**
	 * Returns a copy of all registered listeners.
	 *
	 * @return a copy of the ListenerArray
	 */
	public function getAllListener(Void):ListenerArray {
		var result:ListenerArray = new ListenerArray();
		var l:Number = listeners.length;
		for (var i:Number = 0; i < l; i++) {
			result.push(listeners.get(i));
		}
		return result;
	}
	
	/**
	 * Dispatches to all registered EventListeners.
	 *
	 * @param event the EventInfo to be passed to the operation of the EventListeners
	 */
	public function dispatch(event:EventInfo):Void {
		if (event instanceof Consumeable) {
			dispatcher.dispatchConsumeable(event, listeners);
			return;
		}
		dispatcher.dispatch(event, listeners);
	}
}