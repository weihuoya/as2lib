import org.as2lib.data.holder.Stack;
import org.as2lib.core.BasicInterface;

/**
 * Throwable is the basic interface for every class that will be thrown. You can
 * actually throw every class even if it does not implement this interface but it
 * is recommended to strictly use this interface for every Throwable. It produces 
 * clarity and builds a standard.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.except.Throwable extends BasicInterface {
	/**
	 * Returns a Stack of the operations that were called before this Throwable
	 * was thrown.
	 *
	 * @return a Stack containing the called operations
	 */
	public function getStackTrace(Void):Stack;
	
	/**
	 * Initializes the cause of the Throwable. The cause can only be initialized
	 * once. You normally initialize a cause if you throw a Throwable due to
	 * the throw of another Throwable. Thereby you will not lose the information
	 * the cause offers.
	 * This method returns itself to have an easy way to initialize the cause:
	 * <pre>throw new Throwable("error", this, arguments).initCause(e);</pre>
	 *
	 * @param a Throwable representing the cause of the new Throwable
	 * @return the Throwable itself.
	 * @throws org.as2lib.env.except.IllegalStateException
	 */
	public function initCause(cause:Throwable):Throwable;
	
	/**
	 * Returns the initialized cause.
	 *
	 * @return the initialized cause
	 */
	public function getCause(Void):Throwable;
	
	/**
	 * Returns the message that has been set via the constructor. The message
	 * should describe detailed what went wrong.
	 *
	 * @return the message set via the constructor
	 */
	public function getMessage(Void):String;
}