import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.OutLevel;
import org.as2lib.core.BasicClass;

/**
 * OutWriteInfo is a dumb model that contains all the information needed by the OutHandlers
 * write(OutWriteInfo) operation. These information include the OutLevel the output has as 
 * well as the message that shall be written out.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.out.info.OutWriteInfo extends BasicClass implements EventInfo {
	/** The message that shall be written out. */
	private var message:String;
	
	/** The OutLevel the output has. */
	private var level:OutLevel;
	
	/**
	 * Constructs a new OutInfo instance.
	 * 
	 * @param message the message that shall be written out
	 * @param level the level of the output
	 */
	public function OutWriteInfo(aMessage:String, aLevel:OutLevel) {
		message = aMessage;
		level = aLevel;
	}
	
	/**
	 * Returns the OutLevel of the output. This OutLevel has been set during instantiation.
	 *
	 * @return the level of the output
	 */
	public function getLevel(Void):OutLevel {
		return level;
	}
	
	/**
	 * Returns the message that shall be written out. This message has been set during instantiation.
	 *
	 * @return message the message that shall be written out
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