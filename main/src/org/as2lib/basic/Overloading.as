import org.as2lib.basic.OverloadHandler;
import org.as2lib.util.OverloadingUtil;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
interface org.as2lib.basic.Overloading {
	public function overload(someArguments:Array, someOverloadHandlers:Array):Void;
	public function newOverloadHandler(someArguments:Array, aFunction:String):OverloadHandler;
}