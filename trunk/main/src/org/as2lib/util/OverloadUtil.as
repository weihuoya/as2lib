import org.as2lib.basic.BasicClass;
import org.as2lib.basic.overload.OverloadHandler;
import org.as2lib.basic.overload.SimpleOverloadHandler;
import org.as2lib.basic.overload.OverloadException;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
class org.as2lib.util.OverloadUtil extends BasicClass {
	/**
	 * private constructor.
	 */
	private function OverloadUtil(Void) {
	}
	
	/**
	 * Handles the invocation of the appropriate OverloadHandler.
	 * @param anObject
	 * @param someArguments
	 * @param someOverloadHandlers
	 */
	public static function overload(anObject:Object, someArguments:Array, someOverloadHandlers:Array):Object {
		var handler:OverloadHandler;
		var l:Number = someOverloadHandlers.length;
		for (var i:Number = 0; i < l; i++) {
			handler = OverloadHandler(someOverloadHandlers[i]);
			if (handler != null) {
				if (handler.matches(someArguments)) {
					return handler.execute(anObject, someArguments);
				}
			}
		}
		throw new OverloadException("No appropriate OverloadHandler [" + someOverloadHandlers + "] for the arguments [" + someArguments + "] could be found.",
									 eval("th" + "is"),
									 arguments);
	}
	
	/**
	 * Instantiates a new OverloadHandler.
	 * @param someArguments
	 * @param aFunction
	 * @return an OverloadHandler instance
	 */
	public static function newHandler(someArguments:Array, aFunction:Function):OverloadHandler {
		return (new SimpleOverloadHandler(someArguments, aFunction));
	}
}