﻿/*
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

import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.OverloadHandler;
import org.as2lib.env.overload.SimpleOverloadHandler;
import org.as2lib.env.overload.UnknownOverloadHandlerException;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.overload.SameTypeSignatureException;

/**
 * Overload is used to overload a method.
 *
 * <p>With overloading you have typically two or more methods with the
 * same name. Which method gets actually invoked depends on its type
 * signature, that means its return and arguments' types.
 * Here is an example of what overloading may look if it would be supported
 * by Flash (note that this code does actually not work).
 * 
 * <code>// MyClass.as
 * class MyClass {
 *   public function myMethod(number:Number, string:String):Void {
 *     trace("myMethod(Number, String):Void");
 *   }
 *   public function myMethod(number:Number):Void {
 *     trace("myMethod(Number):Void");
 *   }
 *   public function myMethod(string:String):Number {
 *     trace("myMethod(String):Number");
 *     return 1;
 *   }
 * }
 * // test.fla
 * var myInstance:MyClass = new MyClass();
 * myInstance.myMethod(1);
 * myInstance.myMethod(2, "myString");
 * var number:Number = myInstance.myMethod("myString");
 * trace(number);
 * // the output
 * // myMethod(Number):Void
 * // myMethod(Number, String):Void
 * // myMethod(String):Number
 * // 1</code>
 *
 * <p>As you can see, depending on what type the passed-in arguments
 * have a different method gets invoked. This is sadly not possible in
 * Flash, that is what this class is for. Using the overload mechanism
 * this class offers the overloading would look as follows:
 *
 * <code>// MyClass.as
 * class MyClass {
 *   public functino myMethod() {
 *     var o:Overload = new Overload(this);
 *     o.addHandler([Number, String], myMethodByNumberAndString);
 *     o.addHandler([Number], myMethodByNumber);
 *     o.addHandler([String], myMethodByString);
 *     return o.forward(arguments);
 *   }
 *   public function myMethodByNumberAndString(number:Number, string:String):Void {
 *     trace("myMethod(Number, String):Void");
 *   }
 *   public function myMethodByNumber(number:Number):Void {
 *     trace("myMethod(Number):Void");
 *   }
 *   public function myMethodByString(string:String):Number {
 *     trace("myMethod(String):Number");
 *     return 1;
 *   }
 * }</code>
 *
 * <p>Using the above testing code the output looks the same.
 *
 * <p>While this is a good overloading mechanism / overloading alternative
 * it still has some disadvantages.
 * <ul>
 *   <li>If not all methods the overloaded method forwards to returns a 
 * value of the same type, return type type checking is lost.</li>
 *   <li>The type checking of the arguments is also lost at compile time.
 * At run-time the Overload class throws an UnknownOverloadHandlerException
 * if the real arguments match no added overload handler.</li>
 *   <li>The overloading slows the method execution a little bit down.</li>
 * </ul>
 *
 * <p>But if you declare the methods to overload to as public, as in the
 * example, you can still invoke them directly. Doing so, all the above
 * problems do not hold true anymore.
 * The overloaded methods then acts more as a convenient method that is
 * easy to use if appropriate.
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
	 * <p>The target is the normally the object on which the overloading
	 * takes place.
	 *
	 * @param target the target on which the method will be invoked
	 */
	public function Overload(target) {
		this.handlers = new Array();
		this.target = target;
	}
	
	/**
	 * Sets the default handler.
	 *
	 * <p>This handler will be used if no other handler applies to a list of 
	 * arguments. All real arguments used for the overloading get passed
	 * as parameters to the method of this default handler.
	 *
	 * <p>The method gets executed on the same scope as the other handlers.
	 * That is the target passed-in on construction.
	 * 
	 * <code>var overload:Overload = new Overload(this);
	 * overload.addHandler([String], methodWithStringArgument);
	 * overload.addHandler([Number], methodWithNumberArgument);
	 * overload.setDefaultHandler(function() {
	 *   trace(arguments.length + " arguments were used.");
	 * });
	 * return overload.forward(arguments);</code>
	 *
	 * <p>If the method is null, undefined or not of type function the default
	 * handler gets removed.
	 *
	 * @param method the method of the handler to invoke if no added handler
	 * matches the real arguments
	 * @see #removeDefaultHandler
	 */
	public function setDefaultHandler(method:Function):Void {
		if (typeof(method) == "function") {
			defaultHandler = new SimpleOverloadHandler(null, method);
		} else {
			removeDefaultHandler();
		}
	}
	
	/**
	 * Removes the default handler.
	 *
	 * <p>This handler is used if no other handler applies to a list of
	 * arguments.
	 *
	 * @see #setDefaultHandler
	 */
	public function removeDefaultHandler(Void):Void {
		defaultHandler = null;
	}
	
	/**
	 * @overload #addHandlerByHandler
	 * @overload #addHandlerByValue
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
	 * Adds a new overload handler.
	 *
	 * <p>Overload handlers get used to determine the method to forward
	 * to. This is done using the {@link OverloadHandler#matches} and
	 * {@link OverloadHandler#isMoreExplicit} methods. If both conditions hold true
	 * the method invocation gets forwarded to the method of the handler, that
	 * gets returned by the {@link OverloadHandler#getMethod} method.
	 *
	 * @param handler the new overload handler to add
	 */
	public function addHandlerByHandler(handler:OverloadHandler):Void {
		handlers.push(handler);
	}
	
	/**
	 * Adds a new SimpleOverloadHandler based on the passed-in arguments.
	 *
	 * <p>Overload handlers get used to determine the method to forward
	 * to. This is done using the {@link OverloadHandler#matches} and
	 * {@link OverloadHandler#isMoreExplicit} methods. If both conditions hold true
	 * the method invocation gets forwarded to the method of the handler, that
	 * gets returned by the {@link OverloadHandler#getMethod} method.
	 *
	 * <p>The arguments' types are the types of arguments the method expects
	 * from the real arguments to have. The SimpleOverloadHandler does its
	 * matches and explicity checks upon these arguments' types.
	 *
	 * <p>The method is the method to invoke if the added handler matches
	 * the real arguments and if it is the most explicit handler among all
	 * matching ones.
	 *
	 * @param argumentsTypes the arguments' types of the overload handler
	 * @param method the method corresponding to the passed-in arguments' types
	 * @return the newly created overload handler
	 * @see SimpleOverloadHandler#Constructor
	 */
	public function addHandlerByValue(argumentsTypes:Array, method:Function):OverloadHandler {
		var handler:OverloadHandler = new SimpleOverloadHandler(argumentsTypes, method);
		handlers.push(handler);
		return handler;
	}
	
	/**
	 * Removes the passed-in overload handler.
	 *
	 * <p>All occurrences of the passed-in handler are removed.
	 *
	 * @param handler the overload handler to remove
	 */
	public function removeHandler(handler:OverloadHandler):Void {
		var i:Number = handlers.length;
		while (--i-(-1)) {
			if (handlers[i] == handler) {
				handlers.splice(i, 1);
			}
		}
	}
	
	/**
	 * Forwards the arguments to the corresponding overload handler.
	 *
	 * <p>This is not done by using the {@link OverloadHandler#execute} method but
	 * manually by using apply on the method returned by the {@link OverloadHandler#getMethod}
	 * method.
	 * Invoking the method this way increases the amount of possible
	 * recurions with overlaoded methods.
	 *
	 * <p>If the arguments array is null or undefined an empty array gets
	 * used instead.
	 *
	 * <p>If no overload handler matches the default overload handler
	 * gets used if it has been set.
	 *
	 * <p>Overload handlers are supposed to have the same type signature
	 * if the {@link OverloadHandler#isMoreExplicit} method returns null.
	 *
	 * @return the return value of the invoked method
	 * @throws org.as2lib.env.overload.UnknownOverloadHandlerException if
	 * no adequate overload handler could be found
	 * @throws org.as2lib.env.overload.SameTypeSignatureException if there
	 * exist at least two overload handlers with the same type siganture,
	 * that means their arguments' types are the same
	 */
	public function forward(args:Array) {
		return doGetMatchingHandler(arguments.caller, args).getMethod().apply(target, args);
	}
	
	/**
	 * Returns the most explicit overload handler from the array of matching
	 * handlers.
	 *
	 * <p>If the arguments array is null or undefined an empty array gets
	 * used instead.
	 *
	 * <p>If no handler matches the default handler gets returned if it
	 * has been set.
	 *
	 * <p>Overload handlers are supposed to have the same type signature
	 * if the {@link OverloadHandler#isMoreExplicit} method returns null.
	 *
	 * @param args the arguments that shall match to a specific overload handler
	 * @return the most explicit overload handler
	 * @throws org.as2lib.env.overload.UnknownOverloadHandlerException if
	 * no adequate overload handler could be found
	 * @throws org.as2lib.env.overload.SameTypeSignatureException if there
	 * exist at least two overload handlers with the same type siganture,
	 * that means their arguments' types are the same
	 */
	public function getMatchingHandler(args:Array):OverloadHandler {
		return doGetMatchingHandler(arguments.caller, args);
	}
	
	/**
	 * Returns the most explicit OverloadHandler out of the Array of matching
	 * OverloadHandlers.
	 *
	 * <p>If the arguments array is null or undefined an empty array gets
	 * used instead.
	 *
	 * <p>If no handler matches the default handler gets returned if it
	 * has been set.
	 *
	 * <p>Overload handlers are supposed to have the same type signature
	 * if the {@link OverloadHandler#isMoreExplicit} method returns null.
	 *
	 * @param overloadedMethod the overloaded method on the target
	 * @param overloadArguments the arguments for which the overload shall be performed
	 * @return the most explicit overload handler
	 * @throws org.as2lib.env.overload.UnknownOverloadHandlerException if
	 * no adequate overload handler could be found
	 * @throws org.as2lib.env.overload.SameTypeSignatureException if there
	 * exist at least two overload handlers with the same type siganture,
	 * that means their arguments' types are the same
	 */
	private function doGetMatchingHandler(overloadedMethod:Function, overloadArguments:Array):OverloadHandler {
		if (!overloadArguments) overloadArguments = [];
		var matchingHandlers:Array = getMatchingHandlers(overloadArguments);
		var i:Number = matchingHandlers.length;
		if (i == 0) {
			if (defaultHandler) {
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
	 * Returns OverloadHandler instances that match the passed-in real arguments.
	 *
	 * <p>The match is performed using the {@link OverlaodHandler#matches} method.
	 * 
	 * @param args the arguments that shall match to overload handlers
	 * @return an array containing the matching OverloadHandler instances
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