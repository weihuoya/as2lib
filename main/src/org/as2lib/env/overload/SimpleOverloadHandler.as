import org.as2lib.env.overload.OverloadHandler;
import org.as2lib.util.ObjectUtil;
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.IllegalTypeException;

/**
 * SimpleOverloadHandler is a default implementation of the OverloadHandler interface
 *
 * @author: Simon Wacker
 * @see org.as2lib.core.BasicClass
 * @see org.as2lib.env.overload.OverloadHandler
 */
class org.as2lib.env.overload.SimpleOverloadHandler extends BasicClass implements OverloadHandler {
	/** Contains the arguments types of the operation. */
	private var args:Array;
	
	/** The operation to be executed on the given target. */
	private var func:Function;
	
	/**
	 * Constructs a new SimpleOverloadHandler instance.
	 *
	 * @param args the arguments types of the operation
	 * @param func the actual operation to be executed on the target if the argumetns types match
	 */
	public function SimpleOverloadHandler(args:Array, func:Function) {
		this.args = args;
		this.func = func;
	}
	
	/**
	 * @see org.as2lib.env.overload.OverloadHandler
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
	 * @see org.as2lib.env.overload.OverloadHandler
	 */
	public function execute(target, someArguments:Array) {
		return func.apply(target, someArguments);
	}
	
	/**
	 * @see org.as2lib.env.overload.OverloadHandler
	 */
	public function isMoreExplicitThan(handler:OverloadHandler):Boolean {
		var points:Number = 0;
		var args2:Array = handler.getArguments();
		var l:Number = args.length;
		for (var i:Number = 0; i < l; i++) {
			if (args[i] != args2[i]) {
				if (ObjectUtil.isInstanceOf(args[i].prototype, args2[i])) {
					points++;
				} else {
					points--;
				}
			}
		}
		if (points == 0) {
			throw new IllegalTypeException("The two OverloadHandler [" + this + "] and [" + handler + "] have the same type signature.",
										   this,
										   arguments);
		}
		return (points > 0);
	}
	
	/**
	 * @see org.as2lib.env.overload.OverloadHandler
	 */
	public function getArguments(Void):Array {
		return args;
	}
}