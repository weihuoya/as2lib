import org.as2lib.overload.OverloadHandler;
import org.as2lib.util.ObjectUtil;
import org.as2lib.core.BasicClass;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
class org.as2lib.overload.SimpleOverloadHandler extends BasicClass implements OverloadHandler {
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
	public function SimpleOverloadHandler(args:Array, func:Function) {
		this.args = args;
		this.func = func;
	}
	
	/**
	 * @see org.as2lib.overload.OverloadHandler
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
	 * @see org.as2lib.overload.OverloadHandler
	 */
	public function execute(target, someArguments:Array) {
		return func.apply(target, someArguments);
	}
}