import org.as2lib.env.overload.OverloadException;

/**
 * UnknownOverloadHandlerException will be thrown if no appropriate OverloadHandler
 * could be found.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.except.FatalException
 */
class org.as2lib.env.overload.UnknownOverloadHandlerException extends OverloadException {
	/**
	 * @see org.as2lib.env.overload.OverloadException
	 */
	public function UnknownOverloadHandlerException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}