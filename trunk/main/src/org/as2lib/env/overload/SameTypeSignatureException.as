import org.as2lib.env.overload.OverloadException;

/**
 * SameTypeSignatureException is thrown when two or more OverloadHandlers have
 * the same type signature pending on the passed arguments.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.overload.SameTypeSignatureException extends OverloadException {
	/**
	 * @see org.as2lib.env.overload.OverloadException#Constructor()
	 */
	public function SameTypeSignatureException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}