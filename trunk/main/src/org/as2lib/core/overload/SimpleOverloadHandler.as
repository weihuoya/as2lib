import org.as2lib.core.overload.OverloadHandler;
import org.as2lib.util.ObjectUtil;
import org.as2lib.core.BasicClass;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
class org.as2lib.core.overload.SimpleOverloadHandler extends BasicClass implements OverloadHandler {
	/**
	 * Contains the arguments types of the function.
	 */
	private var args:Array;
	
	/**
	 * The name of the function.
	 */
	private var func:Function;
	
	/**
	 * Constructs a new SimpleOverloadHandler instance.
	 * @param someArguments
	 * @param aFunction
	 */
	public function SimpleOverloadHandler(someArguments:Array, aFunction:Function) {
		args = someArguments;
		func = aFunction;
	}
	
	/**
	 * @see org.as2lib.core.overload.OverloadHandler
	 */
	public function matches(someArguments:Array):Boolean {
		var l:Number = someArguments.length;
		if (l != args.length) {
			return false;
		}
		for (var i:Number = 0; i < l; i++) {
			if (!ObjectUtil.typesMatch(someArguments[i], args[i])) {
				return false;
			}
		}
		return true;
	}
	
	/**
	 * @see org.as2lib.core.overload.OverloadHandler
	 */
	public function execute(anObject, someArguments:Array):Object {
		return func.apply(anObject, someArguments);
	}
}