import org.as2lib.core.BasicClass;
import org.as2lib.env.except.ThrowableStringifier;
import org.as2lib.env.except.StackTraceElementStringifier;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.out.OutAccess;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.EnvConfig;

/**
 * ExceptConfig is the base configuration file for the exceptions. It allows you
 * to configure key parts of the whole exception handling process.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.except.ExceptConfig extends BasicClass {
	/** The Stringifier used to stringify a Throwable */
	private static var throwableStringifier:Stringifier = new ThrowableStringifier();
	
	private static var stackTraceElementStringifier:Stringifier = new StackTraceElementStringifier();
	
	/** The OutAccess that is used by the Throwables toString() operation. */
	private static var out:OutAccess;
	
	/**
	 * Private constructor.
	 */
	private function ExceptConfig(Void) {
	}
	
	/**
	 * Sets the OutAccess instance used by the Throwables toString() operation.
	 *
	 * @param out the new OutAccess instance
	 */
	public static function setOut(newOut:OutAccess):Void {
		out = newOut;
	}
	
	/**
	 * Returns the OutAccess instance currently used to write out Throwables.
	 * If no OutAccess instance has been set manually the OutAccess instance
	 * returned by EnvConifg#getOut() will be used.
	 *
	 * @return the OutAccess instance used to write out Throwables
	 */
	public static function getOut(Void):OutAccess {
		if (ObjectUtil.isEmpty(out)) {
			return EnvConfig.getOut();
		}
		return out;
	}
	
	/**
	 * Sets a new Stringifier that shall be used to stringify Throwables.
	 *
	 * @param stringifier the new Stringifier used to stringify Throwables
	 */
	public static function setThrowableStringifier(newStringifier:Stringifier):Void {
		throwableStringifier = newStringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify Throwables.
	 *
	 * @return the Stringifier that stringifies Throwables
	 */
	public static function getThrowableStringifier(Void):Stringifier {
		return throwableStringifier;
	}
	
	public static function setStackTraceElementStringifier(newStringifier:Stringifier):Void {
		stackTraceElementStringifier = newStringifier;
	}
	
	public static function getStackTraceElementStringifier(Void):Stringifier {
		return stackTraceElementStringifier;
	}
}