import org.as2lib.basic.TypedArray;
import org.as2lib.basic.event.EventDispatcher;
import org.as2lib.basic.event.dispatcher.NormalEventDispatcher;
import org.as2lib.basic.event.dispatcher.LogEventDispatcher;
import org.as2lib.basic.event.EventListener;

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
	 * Sets the appropriate EventDispatcher.
	 * @param log True if logging should be enabled else false
	 */
	public function log(log:Boolean):Void {
		dispatcher = log ? logDispatcher : normalDispatcher;
	}
	
	/**
	 * Adds a new listener to the list of listeners.
	 * @param listener
	 */
	public function addListener(listener:EventListener):Void {
		
	}
}