import org.as2lib.event.EventInfo;
import org.as2lib.out.OutLevel;
import org.as2lib.except.Throwable;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.out.info.OutErrorInfo extends BasicClass implements EventInfo {
	/** The name of the event. */
	private var name:String;
	
	/** The exception. */
	private var throwable:Throwable;
	
	private var level:OutLevel;
	
	/**
	 * Constructs a new OutInfo instance.
	 */
	public function OutErrorInfo(aName:String, aThrowable:Throwable, aLevel:OutLevel) {
		name = aName;
		throwable = aThrowable;
		level = aLevel;
	}
	
	public function getLevel(Void):OutLevel {
		return level;
	}
	
	/**
	 * @return the exception
	 */
	public function getThrowable(Void):Throwable {
		return throwable;
	}
	
	/**
	 * @see org.as2lib.event.EventInfo
	 */
	public function getName(Void):String {
		return name;
	}
}