import org.as2lib.env.except.FatalException;

/**
 * UnknownOverloadHandlerException will be thrown if no appropriate OverloadHandler
 * could be found.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.except.FatalException
 */
class org.as2lib.env.overload.IllegalTypeException extends FatalException {
	/**
	 * @see org.as2lib.env.except.FatalException
	 */
	public function IllegalTypeException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}