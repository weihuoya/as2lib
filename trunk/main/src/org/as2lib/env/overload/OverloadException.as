import org.as2lib.env.except.FatalException;

/**
 * @author Simon Wacker
 * @see org.as2lib.env.except.FatalException
 */
class org.as2lib.env.overload.OverloadException extends FatalException {
	/**
	 * @see org.as2lib.env.except.FatalException
	 */
	public function OverloadException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}