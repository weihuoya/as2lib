/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.env.overload.OverloadHandler;
import org.as2lib.env.overload.SimpleOverloadHandler;
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.UnknownOverloadHandlerException;
import org.as2lib.util.ArrayUtil;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.overload.SameTypeSignatureException;

/**
 * You use this class to overload a method. Create a new instance of it, add the
 * possible OverloadHandlers and call the #forward() operation. If an adequate
 * OverloadHandler could be found the corresponding operation will be executed
 * and the return value will be returned.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.overload.Overload extends BasicClass {
	
	/** The list of registered handlers. */
	private var handlers:Array;
	
	/** Handler to be used if no handler applies. */
	private var defaultHandler:OverloadHandler;
	
	/** The target instance on which the operation will be invoked. */
	private var target;
	
	/**
	 * Constructs a new Overload instance.
	 * 
	 * @param target the target on which the operation will be invoked
	 */
	public function Overload(target) {
		this.handlers = new Array();
		this.target = target;
	}
	
	/**
	 * Sets the default handler, this handler will be used if no other handler applies to a set of arguments.
	 * This handler will get all the arguments that were applied to the method.
	 *
	 * This method will be executed on the same scope as the other handlers!
	 * 
	 * <code>
	 *   var overload:Overload = new Overload(this);
	 *   overload.addHandler([String], methodUsingString);
	 *   overload.addHandler([Number], methodUsingNumber);
	 *   overload.setDefaultHandler(function() {
	 *     trace(arguments.length+" arguments were used");
	 *   });
	 *   return overload.forward(arguments);
	 * </code>
	 *
	 * @param handler Handler to be used if no other handler applies.
	 * @see #removeDefaultHandler
	 */
	public function setDefaultHandler(handler:Function):Void {
		if(typeof handler == "function") {
			defaultHandler = new SimpleOverloadHandler(null, handler);
		} else {
			removeDefaultHandler();
		}
	}
	
	/**
	 * Removes the handler for the case if no handler for a set of arguments was available.
	 * 
	 * @see #setDefaultHandler
	 */
	public function removeDefaultHandler(Void):Void {
		defaultHandler = null;
	}
	
	/**
	 * @overload #addHandlerByHandler(OverloadHandler)
	 * @overload #addHandlerByValue(Array, Function)
	 */
	public function addHandler() {
		var l:Number = arguments.length;
		if (l == 1) {
			var handler:OverloadHandler = OverloadHandler(arguments[0]);
			if (handler != null) {
				addHandlerByHandler(handler);
				return;
			}
		}
		if (l == 2) {
			var args:Array = arguments[0];
			var func:Function = Function(arguments[1]);
			if (args != null && func != null) {
				return addHandlerByValue(args, func);
			}
		}
		throw new IllegalArgumentException("The types of the passed arguments [" + arguments + "] must match one of the available choices.", this, arguments);
	}
	
	/**
	 * Adds a new OverloadHandler to the list of handlers.
	 *
	 * @param handler the new OverloadHandler to be added
	 */
	public function addHandlerByHandler(handler:OverloadHandler):Void {
		handlers.push(handler);
	}
	
	/**
	 * Adds a new SimpleOverloadHandler to the list of handlers based on the passed
	 * arguments.
	 *
	 * @param args the arguments types of the OverloadHandler to be matched
	 * @param method the method corresponding to the passed arguments types
	 * @return the newly created OverloadHandler
	 */
	public function addHandlerByValue(args:Array, method:Function):OverloadHandler {
		var handler:OverloadHandler = new SimpleOverloadHandler(args, method); 
		handlers.push(handler);
		return handler;
	}
	
	/**
	 * Removes an OverloadHandler from the list of handlers.
	 *
	 * @param handler the OverloadHandler to be removed
	 */
	public function removeHandler(handler:OverloadHandler):Void {
		ArrayUtil.removeElement(handlers, handler);
	}
	
	/**
	 * Forwards the arguments to the corresponding OverloadHandler.
	 *
	 * @return the return value of the called operation
	 * @throws org.as2lib.env.overload.UnknownOverloadHandlerException if no adequate OverloadHandler could be found
	 * @throws org.as2lib.env.overload.SameTypeSignatureException if there exist at least two OverloadHandlers with the same type siganture
	 */
	public function forward(args:Array) {
		return doGetMatchingHandler(arguments.caller, args).getMethod().apply(target, args);
	}
	
	/**
	 * Returns the most explicit OverloadHandler out of the Array of matching
	 * OverloadHandlers.
	 *
	 * @param args the arguments that shall match to a specific OverloadHandler
	 * @return the most explicit OverloadHandler
	 */
	public function getMatchingHandler(args:Array):OverloadHandler {
		return doGetMatchingHandler(arguments.caller, args);
	}
	
	/**
	 * Returns the most explicit OverloadHandler out of the Array of matching
	 * OverloadHandlers.
	 *
	 * @param overloadedMethod the overloaded method on the target
	 * @param overloadArguments the arguments for which the overload shall be performed
	 * @return the most explicit OverloadHandler
	 * @throws SameTypeSignatureException if there are two overload handlers with the same type signature
	 * @throws UnknownOverloadHandlerException if there is no matching handler
	 */
	private function doGetMatchingHandler(overloadedMethod:Function, overloadArguments:Array):OverloadHandler {
		if (!overloadArguments) overloadArguments = [];
		var matchingHandlers:Array = getMatchingHandlers(overloadArguments);
		var i:Number = matchingHandlers.length;
		if (i == 0) {
			if(defaultHandler) {
				return defaultHandler;
			}
			throw new UnknownOverloadHandlerException("No appropriate OverloadHandler found.",
									 			  	  this,
									 			  	  arguments,
													  target,
													  overloadedMethod,
													  overloadArguments,
													  handlers);
		}
		var result:OverloadHandler = matchingHandlers[--i];
		while (--i-(-1)) {
			var moreExplicit:Boolean = result.isMoreExplicit(matchingHandlers[i]);
			if (moreExplicit == null) {
				throw new SameTypeSignatureException("Two OverloadHandlers have the same type signature.",
													 this,
													 arguments,
													 target,
													 overloadedMethod,
													 overloadArguments,
													 [result, matchingHandlers[i]]);
			}
			if (!moreExplicit) result = matchingHandlers[i];
		}
		return result;
	}
	
	/**
	 * Returns all OverloadHandlers in an Array that match the given arguments.
	 * 
	 * @param args the arguments that shall match to a specific OverloadHandler
	 * @return an Array containing the matching OverloadHandlers
	 */
	private function getMatchingHandlers(args:Array):Array {
		var result:Array = new Array();
		var i:Number = handlers.length;
		while (--i-(-1)) {
			var handler:OverloadHandler = handlers[i];
			if (handler.matches(args)) result.push(handler);
		}
		return result;
	}
	
}