import org.as2lib.basic.event.EventInfo;
import org.as2lib.basic.out.OutLevel;
import org.as2lib.basic.Throwable;
import org.as2lib.basic.BasicClass;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.OutErrorInfo extends BasicClass implements EventInfo {
	/** The name of the event. */
	private var name:String;
	
	/** The exception. */
	private var exception:Throwable;
	
	private var level:OutLevel;
	
	/**
	 * Constructs a new OutInfo instance.
	 */
	public function OutErrorInfo(aName:String, anException:Throwable, aLevel:OutLevel) {
		name = aName;
		exception = anException;
		level = aLevel;
	}
	
	public function getLevel(Void):OutLevel {
		return level;
	}
	
	/**
	 * @return the exception
	 */
	public function getException(Void):Throwable {
		return exception;
	}
	
	/**
	 * @see org.as2lib.basic.event.EventInfo
	 */
	public function getName(Void):String {
		return name;
	}
}