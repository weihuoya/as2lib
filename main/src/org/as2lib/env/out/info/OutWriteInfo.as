import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.OutLevel;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.env.out.info.OutWriteInfo extends BasicClass implements EventInfo {
	/** The message. */
	private var message:String;
	
	private var level:OutLevel;
	
	/**
	 * Constructs a new OutInfo instance.
	 */
	public function OutWriteInfo(aMessage:String, aLevel:OutLevel) {
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
	 * @see org.as2lib.env.event.EventInfo
	 */
	public function getName(Void):String {
		return "write";
	}
}