import org.as2lib.env.reflect.ReflectException;

/**
 * NoSuchChildException gets thrown to indicate that the specified child could
 * not be found.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.NoSuchChildException extends ReflectException {
	/**
	 * @see org.as2lib.env.reflect.ReflectException#Constructor()
	 */
	public function NoSuchChildException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}