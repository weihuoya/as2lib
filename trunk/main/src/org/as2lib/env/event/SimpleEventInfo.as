import org.as2lib.core.BasicClass;
import org.as2lib.env.event.EventInfo;

/**
 * A simple implementation of the EventInfo interface. You can use this class
 * if you do not want to pass any specific information to the EventListener.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.SimpleEventInfo extends BasicClass implements EventInfo {
	/** Name of the event */
	private var name:String;
	
	/**
	 * Constructs a SimpleEventInfo.
	 */
	public function SimpleEventInfo(name:String) {
		this.name = name;
	}
	
	/**
	 * @see org.as2lib.env.event.EventInfo
	 */
	public function getName(Void):String {
		return this.name;
	}
}