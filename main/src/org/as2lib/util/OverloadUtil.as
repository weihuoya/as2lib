import org.as2lib.basic.overload.OverloadHandler;
import org.as2lib.basic.TypedArray;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
class org.as2lib.util.OverloadUtil {
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
	public static function overload(anObject:Object, someArguments:Array, someOverloadHandlers:TypedArray):Void {
		var oh:OverloadHandler;
		var foundHandler = false;
		var l:Number = someOverloadHandlers.length;
		for (var i:Number = 0; i < l; i++) {
			oh = OverloadHandler(someOverloadHandlers[i]);
			if (oh != null) {
				if (oh.matches(someArguments)) {
					oh.execute(anObject, someArguments);
					// Is it really necessary to thorw an exception if two OverloadHandlers have the same
					// arguments types? Why not just execute both methods?
					if (foundHandler) {
						// throw ...
					}
					foundHandler = true;
				}
			}
		}
	}
	
	/**
	 * Instantiates a new OverloadHandler.
	 * @param someArguments
	 * @param aFunction
	 * @return an OverloadHandler instance
	 */
	public static function newOverloadHandler(someArguments:Array, aFunction:String):OverloadHandler {
		return (new OverloadHandler(someArguments, aFunction));
	}
}