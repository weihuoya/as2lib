import org.as2lib.env.except.Exception;

/**
 * Signals that a method has been invoked at an illegal or inappropriate time.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.except.Exception
 */
class org.as2lib.env.except.IllegalStateException extends Exception {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function IllegalStateException(message:String, thrower
											 , args:FunctionArguments) {
		super (message, thrower, args);
	}
}