import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.OutLevel;
import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.env.out.info.OutErrorInfo extends BasicClass implements EventInfo {
	/** The exception. */
	private var throwable:Throwable;
	
	private var level:OutLevel;
	
	/**
	 * Constructs a new OutInfo instance.
	 */
	public function OutErrorInfo(aThrowable:Throwable, aLevel:OutLevel) {
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
	 * @see org.as2lib.env.event.EventInfo
	 */
	public function getName(Void):String {
		return "error";
	}
}