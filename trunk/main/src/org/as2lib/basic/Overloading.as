import org.as2lib.basic.OverloadHandler;
import org.as2lib.util.OverloadingUtil;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
interface org.as2lib.basic.Overloading {
	/**
	 * Handles the invocation of the appropriate OverloadHandler.
	 * @param someArguments
	 * @param someOverloadHandlers
	 */
	public function overload(someArguments:Array, someOverloadHandlers:Array):Void;
	
	/**
	 * Instantiates a new OverloadHandler.
	 * @param someArguments
	 * @param aFunction
	 * @return an OverloadHandler instance
	 */
	public function newOverloadHandler(someArguments:Array, aFunction:String):OverloadHandler;
}