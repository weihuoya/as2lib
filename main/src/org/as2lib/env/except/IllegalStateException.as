import org.as2lib.env.except.FatalException;

/**
 * Signals that a method has been invoked at an illegal or inappropriate time.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.except.IllegalStateException extends FatalException {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function IllegalStateException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}