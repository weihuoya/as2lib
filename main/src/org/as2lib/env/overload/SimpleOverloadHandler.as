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

import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.overload.OverloadHandler;
import org.as2lib.env.overload.SameTypeSignatureException;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * SimpleOverloadHandler offers basic overloading functionalities.
 *
 * <p>Overload handlers are used by the Overload class to identify the
 * corresponding method for a specific list of arguments. Whereby the
 * overload handler holds the method and the expected arguments' types
 * of this method.
 *
 * <p>It also offers functionalities to match real arguments against the
 * expected arguments' types, #matches, and to determine which overload
 * handler or rather which arguments' types of two handlers are more
 * explicit, #isMoreExplicit.
 *
 * <p>It also offers the ability to invoke/execute the target method
 * on a target scope passing-in a list of real arguments.
 *
 * <p>This class normally does not get used directly but indirectly via
 * the Overload#addHandler method.
 *
 * <p>If you nevertheless want to instantiate it by hand and then use it
 * with the Overload class you can do this as follows:
 *
 * <code>this.myMethod = function(number:Number, string:String):String {
 *   return (number + ", " + string);
 * }
 * var overload:Overload = new Overload(this);
 * var handler:OverloadHandler = new SimpleOverloadHandler([Number, String], myMethod);
 * overload.addHandler(handler);
 * trace(overload.forward([2, "myString"]));</code>
 *
 * <p>Note that the handlers arguments signature (the arguments' types)
 * match exactly the ones of the method 'myMethod'.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.overload.SimpleOverloadHandler extends BasicClass implements OverloadHandler {
	
	/** Contains the arguments types of the method. */
	private var argumentsTypes:Array;
	
	/** The method to be executed on the given target. */
	private var method:Function;
	
	/**
	 * Constructs a new SimpleOverloadHandler instance.
	 *
	 * <p>If the passed-in arguments' types array is null or undefined an
	 * empty array gets used instead.
	 *
	 * <p>The arguments' types are the types of arguments this handler expects
	 * the real arguments to have. The arguments' types thus are also the
	 * types of arguments the method, this handler forwards to, expects.
	 * The #matches and #isMoreExplicit methods do their job based on the
	 * arguments' types.
	 *
	 * <p>An argument type is represented by a class, that is a Function in
	 * Flash. An argument type can for example be Number, String,
	 * org.as2lib.core.BasicClass, org.as2lib.core.BasicInterface or any other
	 * class or interface.
	 *
	 * <p>An argument-type of null or undefined will be interpreted as any
	 * type allowed and is less explicit then any other type.
	 *
	 * <p>The arguments' types determine what method call gets forwarded to
	 * this handler which then invokes the passed-in method. The forwarding
	 * to this handler normally takes place if it's matching the passed-in
	 * real arguments, #matches, and if it is the most explicit overload
	 * handler, #isMoreExplicit.
	 *
	 * @param argumentsTypes the arguments' types of the method
	 * @param method the actual method to be executed on the target if the argumetns types match
	 * @throws IllegalArgumentException if the passed-in method is null or undefined
	 */
	public function SimpleOverloadHandler(argumentsTypes:Array, method:Function) {
		if (!method) throw new IllegalArgumentException("Method to be executed by the overload handler must not be null or undefined.", this, arguments);
		if (!argumentsTypes) argumentsTypes = [];
		this.argumentsTypes = argumentsTypes;
		this.method = method;
	}
	
	/**
	 * Checks whether the passed-in real arguments match the arguments' types
	 * of this overload handler.
	 *
	 * <p>If the passed-in real arguments array equals null or undefined, an
	 * empty array gets used instead.
	 *
	 * <p>If a real argument has the value null or undefined it matches any
	 * type.
	 *
	 * <p>If the expected argument type is null or undefined it matches every
	 * real argument. That means null or undefined gets interpreted as Object,
	 * which also matches every real argument.
	 *
	 * @param realArguments the real arguments to match against the arguments' types
	 * @return true if the real arguments match the arguments' types else false
	 */
	public function matches(realArguments:Array):Boolean {
		if (!realArguments) realArguments = [];
		var i:Number = realArguments.length;
		if (i != argumentsTypes.length) return false;
		while (--i-(-1)) {
			// null == undefined
			if (realArguments[i] != null) {
				// An expected type of value null or undefined gets interpreted as: whatever.
				if (argumentsTypes[i] != null) {
					if (!ObjectUtil.typesMatch(realArguments[i], argumentsTypes[i])) {
						return false;
					}
				}
			}
		}
		return true;
	}
	
	/**
	 * Executes the method of this handler on the target passing-in the
	 * given arguments.
	 *
	 * <p>The 'this' scope of the method refers to the passed-in target on
	 * execution.
	 *
	 * @param target the target object to invoke the method on
	 * @param args the arguments to pass-in on method invocation
	 * @return the result of the method invocation
	 */
	public function execute(target, args:Array) {
		return method.apply(target, args);
	}
	
	/**
	 * Checks if this overload handler is more explicit than the passed-in
	 * handler.
	 *
	 * <p>The check is based on the arguments' types of both handlers. They
	 * get compared one by one.
	 *
	 * <p>What means more explicit? The type String is for example more explicit
	 * than Object. The type org.as2lib.core.BasicClass is also more explicit
	 * than Object. And the type org.as2lib.env.overload.SimpleOverloadHandler
	 * is more explicit than org.as2lib.core.BasicClass. I hope you get the
	 * image. As you can see, the explicity depends on the inheritance
	 * hierarchy.
	 * Classes are also supposed to be more explicit than interfaces.
	 *
	 * <ul>
	 *   <li>If the passed-in handler is null or undefined, true will be returned.</li>
	 *   <li>If the handler's getArguments-method returns null or undefined an empty array will be used instead.</li>
	 *   <li>If the arguments' lengths do not match, true will be returned.</li>
	 *   <li>If one argument-type is null or undefined it is less explicit than no matter what type it gets compared with.</li>
	 * </ul>
	 *
	 * @param handler the handler to compare this handler with regarding explicity
	 * @return true if this handler is more explicit else false or
	 *         null if the two handlers have the same explicity
	 */
	public function isMoreExplicit(handler:OverloadHandler):Boolean {
		// explicity range: null, undefined -> Object -> Number -> ...
		if (!handler) return true;
		var scores:Number = 0;
		var argumentsTypes2:Array = handler.getArgumentsTypes();
		if (!argumentsTypes2) argumentsTypes2 = [];
		var i:Number = argumentsTypes.length;
		if (i != argumentsTypes2.length) return true;
		while (--i-(-1)) {
			if (argumentsTypes[i] != argumentsTypes2[i]) {
				var object = new Object();
				object.__proto__ = argumentsTypes[i].prototype;
				if (!argumentsTypes[i]) {
					scores--;
				} else if (!argumentsTypes2[i]) {
					scores -= -1;
				} else if (ObjectUtil.isInstanceOf(object, argumentsTypes2[i])) {
					scores -= -1;
				} else {
					scores--;
				}
			}
		}
		if (scores == 0) {
			return null;
		}
		return (scores > 0);
	}
	
	/**
	 * Returns the arguments' types used to match against the real arguments.
	 *
	 * <p>The arguments' types determine for which types of arguments the
	 * method was declared for. That means which arguments' types the method
	 * expects.
	 *
	 * @return the arguments' types the method expects
	 */
	public function getArgumentsTypes(Void):Array {
		return argumentsTypes;
	}
	
	/**
	 * Returns the method this overload handler was assigned to.
	 *
	 * <p>This is the method to invoke passing the appropriate arguments
	 * when this handler matches the arguments and is the most explicit one.
	 *
	 * @return the method to invoke when the real arguments match the ones 
	 * of this handler and this handler is the most explicit one
	 */
	public function getMethod(Void):Function {
		return method;
	}
	
	/**
	 * Returns a detailed string representation of this overload handler.
	 *
	 * <p>The string representation is composed as follows:
	 * [object SimpleOverloadHandler(firstArgumentType, ..)]
	 * 
	 * @returns the string representation of this overload handler
	 */
	public function toString(Void):String {
		// TODO: Extract to a Stringifier.
		var result:String = "[object SimpleOverloadHandler";
		var l:Number = argumentsTypes.length;
		if(l > 0) {
			result += "(";
		}
		for(var i:Number = 0; i < l; i++) {
			if(i != 0) {
				result += ", ";
			}
			result += ReflectUtil.getTypeName(argumentsTypes[i]);
		}
		if(l > 0) {
			result += ")";
		}
		return result + "]";
	}
	
}