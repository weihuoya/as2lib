import org.as2lib.basic.event.EventInfo;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.OutInfo implements EventInfo {
	/** Indicates whether the event is consumed. */
	private var consumed:Boolean;
	
	/** The name of the event. */
	private var name:String;
	
	/** The message. */
	private var message:String;
	
	/** The exception. */
	private var exception:Exception;
	
	/**
	 * Constructs a new OutInfo instance.
	 */
	public function OutInfo(aName:String, aMessage:String, anException:Exception) {
		consumed = false;
		name = aName;
		message = aMessage;
		exception = anException;
	}
	
	/**
	 * @return the message
	 */
	public function getMessage(Void):String {
		return message;
	}
	
	/**
	 * @return the exception
	 */
	public function getException(Void):Exception {
		return exception;
	}
	
	/**
	 * @see org.as2lib.basic.event.EventInfo
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * @see org.as2lib.basic.event.EventInfo
	 */
	public function consume(Void):Void {
		consumed = true;
	}
	
	/**
	 * @see org.as2lib.basic.event.EventInfo
	 */
	public function isConsumed(Void):Boolean {
		return consumed;
	}
}