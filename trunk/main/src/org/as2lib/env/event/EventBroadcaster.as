import org.as2lib.env.event.EventListener;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.ListenerArray;
import org.as2lib.core.BasicInterface;

/**
 * Interface for standardized Broadcasting.
 * This interface represents the basic pillar for broadcasting events.
 * The EventBroadcaster allows to add(@see #addListener)/remove(@see #removeListener) listener(@see EventListener) to a pool of listeners(@see ListenerArray); 
 * You can dispatch an Eventinfo(@see EventInfo) to all listener in the pool. This allows multiple informations
 * like ASBroadcaster oder EventBroadcaster. The big advantage in the EventBroadcaster is in the fact that you
 * have implement at least EventInfo and EventListener. If you want use the EventBroadcaster-System in the best way
 * you should extend EventInfo and EventListener for own purpose to define your access to the events.
 * 
 * @version 1.0
 * @autor Martin Heidegger
 */
interface org.as2lib.env.event.EventBroadcaster extends BasicInterface {
	
	/**
	 * Adds a listener to the listener pool.
	 * 
	 * @param listener
	 */
	public function addListener(listener:EventListener):Void;
	
	/**
	 * Removes a listener from the listenerpool.
	 * 
	 * @param listener
	 */
	public function removeListener(listener:EventListener):Void;
	
	/**
	 * Removes all registered listener.
	 */
	public function removeAllListener(Void):Void;
	
	/**
	 * @return A copy of the listenerpool.
	 */
	public function getAllListener(Void):ListenerArray;
	
	/**
	 * Dispatches the events associated with the name cotained in the EventInfo instance.
	 * 
	 * @param event
	 */
	public function dispatch(event:EventInfo):Void;
}