import org.as2lib.data.Stack;
import org.as2lib.basic.BasicInterface;

/**
 * @author Simon Wacker
 * @version 1.0
 */
interface org.as2lib.basic.Throwable extends BasicInterface {
	/**
	 * @return The saved stack of method calls.
	 */
	public function getStack(Void):Stack;
	
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
	
	public function getThrower(Void):Object;
	
	public function getArguments(Void):FunctionArguments;
}