import org.as2lib.env.except.Exception;

/**
 * NoSuchElementException will be thrown if the element you tried to obtain does
 * not exist.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.iterator.NoSuchElementException extends Exception {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function NoSuchElementException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}