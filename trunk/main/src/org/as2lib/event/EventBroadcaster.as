import org.as2lib.event.EventDispatcher;
import org.as2lib.event.dispatcher.NormalEventDispatcher;
import org.as2lib.event.dispatcher.LogEventDispatcher;
import org.as2lib.event.EventListener;
import org.as2lib.event.EventInfo;
import org.as2lib.event.ListenerArray;
import org.as2lib.event.Consumeable;
import org.as2lib.core.BasicClass;

/**
 * @version 1.0
 */
class org.as2lib.event.EventBroadcaster extends BasicClass {
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
	 * @param newDispatcher
	 */
	public function setDispatcher(newDispatcher:EventDispatcher):Void {
		dispatcher = newDispatcher;
	}
	
	/**
	 * Adds a new listener to the list of listeners.
	 * @param listener
	 */
	public function addListener(listener:EventListener):Void {
		listeners.set(listener);
	}
	
	/**
	 * Removes a listener from the list of listeners.
	 * @param listener
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
	 * @return A copy of the listeners array
	 */
	public function getAllListener(Void):ListenerArray {
		var result:ListenerArray = new ListenerArray();
		var l:Number = listeners.length;
		for (var i:Number = 0; i < l; i++) {
			result.set(listeners[i]);
		}
		return result;
	}
	
	/**
	 * Dispatches the events associated with the name cotained in the EventInfo instance.
	 * @param event
	 */
	public function dispatch(event:EventInfo):Void {
		if (event instanceof Consumeable) {
			dispatcher.dispatchConsumeable(event, listeners);
			return;
		}
		dispatcher.dispatch(event, listeners);
	}
}