import org.as2lib.env.reflect.ReflectException;

/**
 * NoSuchMethodException gets thrown to indicate that the specified method could
 * not be found.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.NoSuchMethodException extends ReflectException {
	/**
	 * @see org.as2lib.env.reflect.ReflectException#Constructor()
	 */
	public function NoSuchMethodException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}