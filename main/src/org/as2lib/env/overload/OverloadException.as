import org.as2lib.env.except.FatalException;

/**
 * OverloadException is the base Throwable of the org.as2lib.env.overload package.
 * All Throwables contained in this package extend it.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.overload.OverloadException extends FatalException {
	/**
	 * @see org.as2lib.env.except.FatalException#Constructor()
	 */
	public function OverloadException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}