import org.as2lib.basic.Throwable;
import org.as2lib.basic.BasicInterface;
import org.as2lib.basic.TypedArray;
import org.as2lib.basic.reflect.ClassInfo;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.Exception extends Error implements Throwable, BasicInterface {
	/** The root cause of the exception. */
	private var cause:Throwable;
	
	/** The message. */
	private var message:String;
	
	/** All stack information is stored in here. */
	private var stack:TypedArray;
	
	/**
	 * Constructs a new Exception instance.
	 */
	public function Exception(aMessage:String, someArguments:Array) {
		message = aMessage;
	}
	
	/**
	 * @see org.as2lib.basic.Throwable
	 */
	public function toString(Void):String {
		return message;
	}
	
	/**
	 * @see org.as2lib.basic.Throwable
	 */
	public function getStack(Void):TypedArray {
		return stack;
	}
	
	/**
	 * @see org.as2lib.basic.Throwable
	 */
	public function getStackTrace(Void):String {
		return "";
	}
	
	/**
	 * @see org.as2lib.basic.Throwable
	 */
	public function initCause(aCause:Throwable):Void {
		if (cause != undefined) {
			throw new Error();
		}
		cause = aCause;
	}
	
	/**
	 * @see org.as2lib.basic.Throwable
	 */
	public function getCause(Void):Throwable {
		return cause;
	}
	
	/**
	 * @see org.as2lib.basic.Throwable
	 */
	public function getMessage(Void):String {
		return message;
	}
	
	/**
	 * @see org.as2lib.basic.BasicInterface
	 */
	public function getClass(Void):ClassInfo {
		return new ClassInfo();
	}
}