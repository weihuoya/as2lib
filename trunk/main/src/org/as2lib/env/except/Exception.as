import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicInterface;
import org.as2lib.env.except.AbstractException;
import org.as2lib.env.except.ExceptConfig;
import org.as2lib.util.ObjectUtil;

/**
 * Exception is a normal default implementation of the Throwable interface.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.except.Exception extends AbstractException implements Throwable {
	/**
	 * Constructs a new Exception.
	 *
	 * @see org.as2lib.env.except.AbstractException#Constructor()
	 */
	public function Exception(message:String, thrower, args:FunctionArguments) {
		super(message, thrower, args);
	}
	
	/**
	 * Returns a blank String if the operation is not called out of an operation.
	 * This operation should only be called by the virtual machine. We use it to
	 * determine when the Exception has reached the final level and now terminates
	 * the current thread. It then uses the ExceptConfig#getOut()#error() operation
	 * to write out the Throwable.
	 *
	 * @return a blank String if the operation is not called out of an operation, otherwise the result of ExceptConfig#getThrowableStringifier()#execute(this) will be returned
	 */
	public function toString(Void):String {
		if (ObjectUtil.isEmpty(arguments.caller)) {
			ExceptConfig.getOut().error(this);
			return "";
		}
		return ExceptConfig.getThrowableStringifier().execute(this);
	}
}