import org.as2lib.basic.OverloadHandler;
import org.as2lib.util.ObjectUtil;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
class org.as2lib.basic.SimpleOverloadHandler implements OverloadHandler {
	/**
	 * Contains the arguments types of the function.
	 */
	private var args:Array;
	
	/**
	 * The name of the function.
	 */
	private var func:String;
	
	/**
	 * Constructs a new SimpleOverloadHandler instance.
	 * @param someArguments
	 * @param aFunction
	 */
	public function SimpleOverloadHandler(someArguments:Array, aFunction:String) {
		args = someArguments;
		func = aFunction;
	}
	
	/**
	 * @see org.as2lib.basic.OverloadHandler
	 */
	public function matches(someArguments:Array):Boolean {
		var l:Number = someArguments.length;
		if (l != args.length) {
			return false;
		}
		for (var i:Number = 0; i < l; i++) {
			if (ObjectUtil.isPrimitiveType(someArguments[i])) {
				if (ObjectUtil.typesMatch(args[i](someArguments[i]), someArguments[i])) {
					return true;
				}
			} else {
				if (ObjectUtil.isInstanceOf(someArguments[i], args[i])) {
					return true;
				}
			}
		}
		return false;
	}
	
	/**
	 * @see org.as2lib.basic.OverloadHandler
	 */
	public function execute(anObject:Object, someArguments:Array):Void {
		anObject[func].apply(null, someArguments);
	}
}