import org.as2lib.env.except.Exception;

/**
 * @author Simon Wacker
 * @see org.as2lib.env.except.Exception
 */
class org.as2lib.data.holder.DataHolderException extends Exception {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function DataHolderException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}