import org.as2lib.data.holder.DataHolderException;

/**
 * EmptyDataHolderException will be thrown if an operation is called on an empty
 * data holder that requires at least one element to be available.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.EmptyDataHolderException extends DataHolderException {
	/**
	 * @see org.as2lib.env.except.Exception#Constructor()
	 */
	public function EmptyDataHolderException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}