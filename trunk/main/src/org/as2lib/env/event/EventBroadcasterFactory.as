import org.as2lib.core.BasicInterface;
import org.as2lib.env.event.EventBroadcaster;

/**
 * Broadcasterfactory to generate Broadcasters.
 * 
 * @author Martin Heidegger
 */
interface org.as2lib.env.event.EventBroadcasterFactory extends BasicInterface {
	/**
	 * Creates and returns a new instance of a EventBroadcasterimplementation.
	 * 
	 * @return A new instance of a class that implements the EventBroadcaster
	 */
	public function createEventBroadcaster(Void):EventBroadcaster;
}