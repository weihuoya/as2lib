import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.OutLevel;
import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicClass;

/**
 * OutErrorInfo is a dumb model that contains all the information needed by the OutHandlers
 * error() operation. These information include the OutLevel the output has as 
 * well as the Throwable that shall be written out.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.out.info.OutErrorInfo extends BasicClass implements EventInfo {
	/** The Throwable that shall be written out. */
	private var throwable:Throwable;
	
	/** The OutLevel the output has. */
	private var level:OutLevel;
	
	/**
	 * Constructs a new OutInfo instance.
	 *
	 * @param throwable the Throwable that shall be written out
	 * @param level the level of the output
	 */
	public function OutErrorInfo(aThrowable:Throwable, aLevel:OutLevel) {
		throwable = aThrowable;
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
	 * Returns the Throwable that shall be written out. This Throwable has been set during
	 * instantiation.
	 *
	 * @return the throwable that shall be written out
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