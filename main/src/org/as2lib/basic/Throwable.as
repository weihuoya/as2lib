import org.as2lib.basic.TypedArray;

/**
 * @author Simon Wacker
 * @version 1.0
 */
interface org.as2lib.basic.Throwable {
	/**
	 * @return The string representation of the class.
	 */
	public function toString(Void):String;
	
	/**
	 * @return The saved stack of method calls.
	 */
	public function getStack(Void):TypedArray;
	
	/**
	 * @return A string representation of the stack.
	 */
	public function getStackTrace(Void):String;
	
	/**
	 * Initializes the cause. A cause can only be initialized once.
	 * @param cause
	 */
	public function initCause(cause:Throwable):Void;
	
	/**
	 * @return The initialized cause.
	 */
	public function getCause(Void):Throwable;
	
	/**
	 * @return The message that has been set by the thrower.
	 */
	public function getMessage(Void):String;
}