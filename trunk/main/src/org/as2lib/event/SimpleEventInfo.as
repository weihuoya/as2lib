import org.as2lib.basic.BasicClass;
import org.as2lib.event.EventInfo;

/**
 * @version 1.0
 */
class org.as2lib.event.SimpleEventInfo extends BasicClass implements EventInfo {
	/** Name of the event */
	private var name:String;
	
	/**
	 * Constructs a Simple EventInfo Class.
	 */
	public function SimpleEventInfo(name:String) {
		this.name = name;
	}
	
	/**
	 * @return The specified name.
	 */
	public function getName(Void):String {
		return this.name;
	}
}