import org.as2lib.env.overload.OverloadHandler;
import org.as2lib.env.overload.SimpleOverloadHandler;
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.UnknownOverloadHandlerException;
import org.as2lib.util.ArrayUtil;

/**
 * You use this class to overload a method. Create a new instance of it, add the
 * possible OverloadHandlers and call the #forward() operation. If an adequate
 * OverloadHandler could be found the corresponding operation will be executed
 * and the return value will be returned.
 *
 * @author: Simon Wacker
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.overload.Overload extends BasicClass {
	/** The list of registered handlers. */
	private var handlers:Array;
	
	/** The target instance on which the operation will be invoked. */
	private var target;
	
	/**
	 * Constructs a new Overload instance.
	 * 
	 * @param target the target on which the operation will be invoked
	 * @param args the arguments whose types shall be matched to a specific handler
	 */
	public function Overload(target) {
		this.handlers = new Array();
		this.target = target;
	}
	
	/**
	 * Adds a new OverloadHandler to the list of handlers.
	 *
	 * @param handler the new OverloadHandler to be registered
	 */
	public function addHandler(handler:OverloadHandler):Void {
		handlers.push(handler);
	}
	
	/**
	 * Adds a new SimpleOverloadHandler to the list of handlers based on the passed
	 * arguments. You can use this operation if you just wanna use the default
	 * OverloadHandler.
	 *
	 * @param args the arguments types of the OverloadHandler to be matched
	 * @param func the function corresponding to the passed arguments types
	 * @return the newly created OverloadHandler
	 */
	public function addHandlerByValue(args:Array, func:Function):OverloadHandler {
		var handler:OverloadHandler = new SimpleOverloadHandler(args, func); 
		handlers.push(handler);
		return handler;
	}
	
	/**
	 * Removes an OverloadHandler from the list of handlers. If the OverloadHandler
	 * could not be found on the list the IllegalArgumentException will be thrown.
	 *
	 * @param handler the OverloadHandler to be removed
	 * @throws org.as2lib.env.except.IllegalArgumentException if the specified OverloadHandler does not exist in the list of handlers
	 */
	public function removeHandler(handler:OverloadHandler):Void {
		ArrayUtil.removeElement(handlers, handler);
	}
	
	/**
	 * Forwards the arguments to the corresponding OverloadHandler. The
	 * UnknownOverloadHandlerException will be thrown if no adequate OverloadHandler
	 * could be found.
	 *
	 * @return the return value of the called operation
	 * @throws org.as2lib.env.overload.UnknownOverloadHandlerException if no adequate OverloadHandler could be found
	 */
	public function forward(args:Array) {
		var handler:OverloadHandler;
		var matchingHandlers:Array = new Array();
		var l:Number = handlers.length;
		for (var i:Number = 0; i < l; i++) {
			handler = OverloadHandler(handlers[i]);
			if (handler.matches(args)) {
				matchingHandlers.push(handler);
			}
		}
		if (matchingHandlers.length == 0) {
			throw new UnknownOverloadHandlerException("No appropriate OverloadHandler [" + handlers + "] for the arguments [" + args + "] could be found.",
									 			  	  this,
									 			  	  arguments);
		}
		var currentHandler:OverloadHandler = OverloadHandler(matchingHandlers[0]);
		for (var i:Number = 1; i < matchingHandlers.length; i++) {
			if (!currentHandler.isMoreExplicitThan(OverloadHandler(matchingHandlers[i]))) {
				currentHandler = OverloadHandler(matchingHandlers[i]);
			}
		}
		return currentHandler.execute(target, args);
	}
}