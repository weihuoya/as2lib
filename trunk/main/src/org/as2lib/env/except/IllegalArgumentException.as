import org.as2lib.env.except.Exception;

/**
 * IllegalArgumentException gets thrown to indicate that a method has been passed 
 * an illegal or inappropriate argument.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.except.Exception
 */
class org.as2lib.env.except.IllegalArgumentException extends Exception {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function IllegalArgumentException(message:String, thrower
											 , args:FunctionArguments) {
		super (message, thrower, args);
	}
}