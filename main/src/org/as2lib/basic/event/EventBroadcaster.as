import org.as2lib.basic.TypedArray;
import org.as2lib.basic.event.EventDispatcher;
import org.as2lib.basic.event.dispatcher.NormalEventDispatcher;
import org.as2lib.basic.event.dispatcher.LogEventDispatcher;
import org.as2lib.basic.event.EventListener;
import org.as2lib.basic.event.EventInfo;

/**
 * @version 1.0
 */
class org.as2lib.basic.event.EventBroadcaster {
	/** A reference to the NormalEventDispatcher. */
	public static var normalDispatcher:EventDispatcher = new NormalEventDispatcher();
	
	/** A reference to the LogEventDispatcher. */
	public static var logDispatcher:EventDispatcher = new LogEventDispatcher();
	
	/** Contains all registered listeners. */
	private var listeners:TypedArray;
	
	/** The used EventDispatcher */
	private var dispatcher:EventDispatcher;
	
	/**
	 * Constructs a new EventBroadcaster instance.
	 */
	public function EventBroadcaster(Void) {
		dispatcher = normalDispatcher;
		listeners = new TypedArray(EventListener);
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
		if (listeners.contains(Object(listener))) {
			//throw new Exception();
		}
		listeners.push(Object(listener));
	}
	
	/**
	 * Removes a listener from the list of listeners.
	 * @param listener
	 */
	public function removeListener(listener:EventListener):Void {
		var l:Number = listeners.length;
		for (var i:Number = 0; i <= l; i++) {
			if (listeners[i] === listener) {
				listeners.splice(i,1);
				return;
			}
		}
		//throw new Exception();
	}
	
	/**
	 * @return A copy of the listeners array
	 */
	public function getListeners(Void):TypedArray {
		var result:TypedArray = new TypedArray();
		var l:Number = listeners.length;
		for (var i:Number = 0; i < l; i++) {
			result[i] = listeners[i];
		}
		return result;
	}
	
	/**
	 * Dispatches the events associated with the name cotained in the EventInfo instance.
	 * @param event
	 */
	public function dispatch(event:EventInfo):Void {
		dispatcher.dispatch(event, listeners);
	}
}