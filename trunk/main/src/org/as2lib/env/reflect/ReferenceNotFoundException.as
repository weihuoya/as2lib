import org.as2lib.env.except.Exception;

/**
 * ReferenceNotFoundException gets thrown to indicate that a reference to a specific
 * object could not be found.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ReferenceNotFoundException extends Exception {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function ReferenceNotFoundException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}