import org.as2lib.env.except.Throwable;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.data.holder.Stack;

/**
 * AbstractException is an abstract class that contains rolled out functionalities
 * used by both the class Exception and the class FatalException.
 *
 * @author Simon Wacker
 * @see Error
 */
class org.as2lib.env.except.AbstractException extends Error {
	/** The saved stack of operation calls. */
	private var stackTrace:Stack;
	
	/** The Throwable that caused this Throwable to be thrown. */
	private var cause:Throwable;
	
	/** The message describing what was wrong. */
	private var message:String;
	
	/**
	 * The private constructor.
	 *
	 * @param message the message describing what went wrong
	 * @param thrower the instance that throwed the Throwable
	 * @param args the arguments of the throwing operation
	 */
	private function AbstractException(message:String, thrower, args:FunctionArguments) {
		stackTrace = new Stack();
		this.message = message;
		addStackTraceElement(thrower, args.callee);
	}
	
	private function addStackTraceElement(thrower, method:Function):Void {
		var element:StackTraceElement = new StackTraceElement(thrower, method);
		stackTrace.push(element);
	}
	
	/**
	 * @see org.as2lib.env.except.Throwable#getStack()
	 */
	public function getStackTrace(Void):Stack {
		return stackTrace;
	}
	
	/**
	 * @see org.as2lib.env.except.Throwable#getCause()
	 */
	public function getCause(Void):Throwable {
		return cause;
	}
	
	/**
	 * @see org.as2lib.env.except.Throwable#initCause()
	 */
	public function initCause(aCause:Throwable):Void {
		if (ObjectUtil.isAvailable(cause)) {
			throw new IllegalStateException("The cause [" + cause + "] has already been initialized.",
											this,
											arguments);
		}
		cause = aCause;
	}
	
	/**
	 * @see org.as2lib.env.except.Throwable#getMessage()
	 */
	public function getMessage(Void):String {
		return message;
	}
	
	/**
	 * Uses the ReflectUtil#getClassInfo() operation to fulfill the task.
	 *
	 * @see org.as2lib.core.BasicInterface#getClass()
	 */
	public function getClass(Void):ClassInfo {
		return ReflectUtil.getClassInfo(this);
	}
}