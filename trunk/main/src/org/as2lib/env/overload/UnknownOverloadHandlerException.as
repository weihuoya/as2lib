import org.as2lib.env.overload.OverloadException;

/**
 * UnknownOverloadHandlerException will be thrown if no appropriate OverloadHandler
 * could be found.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.overload.UnknownOverloadHandlerException extends OverloadException {
	/**
	 * @see org.as2lib.env.overload.OverloadException#Constructor()
	 */
	public function UnknownOverloadHandlerException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}