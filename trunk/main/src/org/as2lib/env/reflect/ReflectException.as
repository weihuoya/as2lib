import org.as2lib.env.except.Exception;

/**
 * ReflectException is extended by all exceptions within the reflect package.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ReflectException extends Exception {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function ReflectException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}