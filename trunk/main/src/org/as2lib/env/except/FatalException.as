import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicInterface;
import org.as2lib.env.except.AbstractException;
import org.as2lib.env.except.ExceptConfig;
import org.as2lib.util.ObjectUtil;

/**
 * FatalException is a default implementation of the Throwable interface. It is
 * different from the Exception in that it marks the Throwable as fatal. Which
 * has a higher priority/level than the normal Exception.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.except.AbstractException
 * @see org.as2lib.env.except.Throwable
 */
class org.as2lib.env.except.FatalException extends AbstractException implements Throwable {
	/**
	 * Constructs a new FatalException.
	 *
	 * @see org.as2lib.env.except.AbstractException#Constructor()
	 */
	public function FatalException(message:String, thrower, args:FunctionArguments) {
		super(message, thrower, args);
	}
	
	/**
	 * Returns a blank String. This operation should only be called by the virtual
	 * machine. We use it to determine when the Exception has reached the final
	 * level and now terminates the current thread. It then uses the
	 * ExceptConfig#getOut()#fatal() operation to write out the Throwable.
	 *
	 * @return a blank String
	 */
	public function toString(Void):String {
		if (ObjectUtil.isEmpty(arguments.caller)) {
			ExceptConfig.getOut().fatal(this);
			return "";
		}
		return ExceptConfig.getThrowableStringifier().execute(this);
	}
}