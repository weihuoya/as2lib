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
	 * Overload
	 * #addHandlerByHandler()
	 * #addHandlerByValue()
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
			// Why does 'var args:Array = Array(arguments[0]);' not work?
			var args:Array = arguments[0];
			var func:Function = Function(arguments[1]);
			if (args != null && func != null) {
				return addHandlerByValue(args, func);
			}
		}
		throw new IllegalArgumentException("The types of the passed arguments [" + arguments + "] must match one of the available choices.",
										   this,
										   arguments);
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
	 * could be found. If there exist at least to OverloadHandlers with the same
	 * type signature a SameTypeSignatureException will be thrown.
	 *
	 * @return the return value of the called operation
	 * @throws org.as2lib.env.overload.UnknownOverloadHandlerException if no adequate OverloadHandler could be found
	 * @throws org.as2lib.env.overload.SameTypeSignatureException if there exist at least two OverloadHandlers with the same type siganture
	 */
	public function forward(args:Array) {
		var matchingHandlers:Array = getMatchingHandlers(args);
		if (matchingHandlers.length == 0) {
			throw new UnknownOverloadHandlerException("No appropriate OverloadHandler [" + handlers + "] for the arguments [" + args + "] could be found.",
									 			  	  this,
									 			  	  arguments);
		}
		return getMatchingHandler(matchingHandlers).execute(target, args);
	}
	
	/**
	 * Returns all OverloadHandlers in an Array that match the given arguments.
	 * 
	 * @param args the arguments that shall match to a specific OverloadHandler
	 * @return an Array containing the matching OverloadHandlers
	 */
	private function getMatchingHandlers(args:Array):Array {
		var result:Array = new Array();
		var handler:OverloadHandler;
		for (var i:Number = 0; i < handlers.length; i++) {
			handler = OverloadHandler(handlers[i]);
			if (handler.matches(args)) {
				result.push(handler);
			}
		}
		return result;
	}
	
	/**
	 * Returns the most explicit OverloadHandler out of the Array of matching
	 * OverloadHandlers.
	 *
	 * @param handlers the matching OverloadHandlers found by the #getMatchingHandlers() operation
	 * @return the most explicit OverloadHandler
	 */
	private function getMatchingHandler(matchingHandlers:Array):OverloadHandler {
		var result:OverloadHandler = OverloadHandler(matchingHandlers[0]);
		for (var i:Number = 1; i < matchingHandlers.length; i++) {
			if (!result.isMoreExplicitThan(OverloadHandler(matchingHandlers[i]))) {
				result = OverloadHandler(matchingHandlers[i]);
			}
		}
		return result;
	}
}