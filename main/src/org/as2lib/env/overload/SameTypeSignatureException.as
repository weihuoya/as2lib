import org.as2lib.env.overload.OverloadException;

/**
 * @author Simon Wacker
 * @see org.as2lib.env.except.FatalException
 */
class org.as2lib.env.overload.SameTypeSignatureException extends OverloadException {
	/**
	 * @see org.as2lib.env.overload.OverloadException
	 */
	public function SameTypeSignatureException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}