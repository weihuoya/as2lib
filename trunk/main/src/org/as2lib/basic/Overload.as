import org.as2lib.basic.overload.OverloadHandler;
import org.as2lib.basic.BasicInterface;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
interface org.as2lib.basic.Overload extends BasicInterface {
	/**
	 * Handles the invocation of the appropriate OverloadHandler.
	 * @param someArguments
	 * @param someOverloadHandlers
	 */
	public function overload(someArguments:Array, someOverloadHandlers:Array):Object;
	
	/**
	 * Instantiates a new OverloadHandler.
	 * @param someArguments
	 * @param aFunction
	 * @return an OverloadHandler instance
	 */
	public function newOverloadHandler(someArguments:Array, aFunction:Function):OverloadHandler;
}