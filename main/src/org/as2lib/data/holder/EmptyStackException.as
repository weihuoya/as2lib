import org.as2lib.data.holder.DataHolderException;

/**
 * @author Simon Wacker
 * @see org.as2lib.env.except.Exception
 */
class org.as2lib.data.holder.EmptyStackException extends DataHolderException {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function EmptyStackException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}