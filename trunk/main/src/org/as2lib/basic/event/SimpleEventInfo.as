import org.as2lib.basic.BasicClass;

/**
 * @version 1.0
 */
class org.as2lib.basic.event.SimpleEventInfo extends BasicClass implements org.as2lib.basic.event.EventInfo {
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