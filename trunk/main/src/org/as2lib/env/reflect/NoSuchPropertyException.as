import org.as2lib.env.reflect.ReflectException;

/**
 * NoSuchPropertyException gets thrown to indicate that the specified property could
 * not be found.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.NoSuchPropertyException extends ReflectException {
	/**
	 * @see org.as2lib.env.reflect.ReflectException#Constructor()
	 */
	public function NoSuchPropertyException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}