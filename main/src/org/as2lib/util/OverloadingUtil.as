import org.as2lib.basic.OverloadHandler;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
class org.as2lib.util.OverloadingUtil {
	private function OverloadingUtil(Void) {
	}
	
	public static function overload(anObject:Object, someArguments:Array, someOverloadHandlers:Array):Void {
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
	public static function newOverloadHandler(someArguments:Array, aFunction:String):OverloadHandler {
		return (new OverloadHandler(someArguments, aFunction));
	}
}