import org.as2lib.core.BasicInterface;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.event.EventInfo extends BasicInterface {
	/**
	 * Returns the name of the event. The name of the event equals the operation
	 * that will be called on the EventListeners.
	 *
	 * @return The specified name.
	 */
	public function getName(Void):String;
}