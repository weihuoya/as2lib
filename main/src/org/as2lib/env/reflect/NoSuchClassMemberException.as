import org.as2lib.env.reflect.ReflectException;

/**
 * NoSuchClassMemberException gets thrown to indicate that the specified class
 * member could not be found.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.NoSuchClassMemberException extends ReflectException {
	/**
	 * @see org.as2lib.env.reflect.ReflectException#Constructor()
	 */
	public function NoSuchClassMemberException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}