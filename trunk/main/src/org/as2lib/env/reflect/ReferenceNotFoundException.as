import org.as2lib.env.reflect.ReflectException;

/**
 * ReferenceNotFoundException gets thrown to indicate that a reference to a specific
 * object could not be found.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ReferenceNotFoundException extends ReflectException {
	/**
	 * @see org.as2lib.env.reflect.ReflectException#Constructor()
	 */
	public function ReferenceNotFoundException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}