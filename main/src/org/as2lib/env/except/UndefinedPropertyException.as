import org.as2lib.env.except.FatalException;

/**
 * UndefinedPropertyException gets thrown to indicate that a property is not set. 
 *
 * @author Martin Heidegger
 */
class org.as2lib.env.except.UndefinedPropertyException extends FatalException {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function UndefinedPropertyException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}