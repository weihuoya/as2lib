import org.as2lib.env.except.Exception;

/**
 * DataHolderException is the base Exception of the org.as2lib.data.holder package.
 * All Exceptions contained in this package extend it.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.DataHolderException extends Exception {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function DataHolderException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}