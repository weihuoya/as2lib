import org.as2lib.data.holder.DataHolderException;

/**
 * @author Simon Wacker
 * @see org.as2lib.env.except.Exception
 */
class org.as2lib.data.holder.EmptyQueueException extends DataHolderException {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function EmptyQueueException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}