import org.as2lib.event.EventInfo;
import org.as2lib.out.OutLevel;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.out.info.OutWriteInfo extends BasicClass implements EventInfo {
	/** The name of the event. */
	private var name:String;
	
	/** The message. */
	private var message:String;
	
	private var level:OutLevel;
	
	/**
	 * Constructs a new OutInfo instance.
	 */
	public function OutWriteInfo(aName:String, aMessage:String, aLevel:OutLevel) {
		name = aName;
		message = aMessage;
		level = aLevel;
	}
	
	public function getLevel(Void):OutLevel {
		return level;
	}
	
	/**
	 * @return the message
	 */
	public function getMessage(Void):String {
		return message;
	}
	
	/**
	 * @see org.as2lib.event.EventInfo
	 */
	public function getName(Void):String {
		return name;
	}
}