import org.as2lib.env.overload.OverloadHandler;
import org.as2lib.env.overload.SimpleOverloadHandler;
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.UnknownOverloadHandlerException;
import org.as2lib.env.overload.OverloadException;

/**
 * @author: Simon Wacker
 * @version: 1.0
 */
class org.as2lib.env.overload.Overload extends BasicClass {
	private var handlers:Array;
	private var args:Array;
	private var target:Object;
	
	public function Overload(target, args:Array) {
		this.target = target;
		this.args = args;
	}
	
	public function addHandler(handler:OverloadHandler):Void {
		handlers.push(handler);
	}
	
	public function addHandlerByValue(args:Array, func:Function):OverloadHandler {
		var handler:OverloadHandler = new SimpleOverloadHandler(args, func); 
		handlers.push(handler);
		return handler;
	}
	
	public function removeHandler(handler:OverloadHandler):Void {
		var l:Number = handlers.length;
		for (var i:Number = 0; i < l; i++) {
			if (handlers[i] == handler) {
				handlers[i].splice(i, 1);
				return;
			}
		}
		throw new UnknownOverloadHandlerException("The OverloadHandler [" + handler + "] you tried to remove does not exist.", 
												  this,
												  arguments);
	}
	
	public function forward(Void) {
		var handler:OverloadHandler;
		var l:Number = handlers.length;
		for (var i:Number = 0; i < l; i++) {
			handler = OverloadHandler(handlers[i]);
			if (handler.matches(args)) {
				return handler.execute(target, args);
			}
		}
		throw new UnknownOverloadHandlerException("No appropriate OverloadHandler [" + handlers + "] for the arguments [" + args + "] could be found.",
									 eval("th" + "is"),
									 arguments);
	}
}