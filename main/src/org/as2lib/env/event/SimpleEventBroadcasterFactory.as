import org.as2lib.core.BasicClass;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.EventBroadcasterFactory;
import org.as2lib.env.event.SimpleEventBroadcaster;

/**
 * Broadcasterfactory to generate SimpleEventBroadcaster.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.env.event.SimpleEventBroadcasterFactory extends BasicClass implements EventBroadcasterFactory {
	/**
	 * Creates and returns a new instance of a SimpleEventBroadcaster.
	 * 
	 * @return A new instance of SimpleEventBroadcaster.
	 */
	public function createEventBroadcaster(Void):EventBroadcaster {
		return EventBroadcaster(new SimpleEventBroadcaster());
	}
}