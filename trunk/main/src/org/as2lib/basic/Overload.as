import org.as2lib.basic.overload.OverloadHandler;
import org.as2lib.basic.TypedArray;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
interface org.as2lib.basic.Overload {
	/**
	 * Handles the invocation of the appropriate OverloadHandler.
	 * @param someArguments
	 * @param someOverloadHandlers
	 */
	public function overload(someArguments:Array, someOverloadHandlers:TypedArray):Void;
	
	/**
	 * Instantiates a new OverloadHandler.
	 * @param someArguments
	 * @param aFunction
	 * @return an OverloadHandler instance
	 */
	public function newOverloadHandler(someArguments:Array, aFunction:String):OverloadHandler;
}