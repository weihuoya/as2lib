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

import org.as2lib.env.overload.OverloadException;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * SameTypeSignatureException is thrown when two or more overload handlers
 * have the same type signature.
 *
 * <p>Compared are the arguments' types of two overload handlers. This
 * is mostly done using the OverloadHandler#isMoreExplicit method.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.overload.SameTypeSignatureException extends OverloadException {
	
	/** Exception printed as string */
	private var asString:String;
	
	/** Arguments used by overloading */
	private var overloadArguments:Array;
	
	/** Handlers that where available by the unknown overloadHandler */
	private var overloadHandlers:Array;
	
	/** The object on which the overload should have taken place. */
	private var overloadTarget;
	
	/** The method that performs the overloading. */
	private var overloadedMethod;
	
	/**
	 * Constructs a new SameTypeSignatureException instance.
	 * 
	 * @param message the message of the exception
	 * @param thrower the object whose method threw the exception
	 * @param args the arguments of the method that threw the exception
	 * @param overloadTarget the target object the method should be invoked on / on which the overload is performed
	 * @param overloadedMethod the method that is overloaded
	 * @param overloadArguments the real arguments used to perform the overloading
	 * @param overloadHandlers an array containing OverloadHandler instances
	 * that have the same type signature
	 */
	public function SameTypeSignatureException(message:String, thrower, args:Array, overloadTarget, overloadedMethod:Function, overloadArguments:Array, overloadHandlers:Array) {
		super (message, thrower, args);
		this.overloadTarget = overloadTarget;
		this.overloadedMethod = overloadedMethod;
		this.overloadArguments = overloadArguments;
		this.overloadHandlers = overloadHandlers;
	}
	
	/**
	 * Returns a well formatted informative string representation of this
	 * exceptions.
	 * 
	 * @return the string representation of this exception
	 */
	public function toString(Void):String {
		// The resulting string gets constructed lazily and gets stored once it has been generated.
		// It would take unnecessary much time to generate the string representation if you'd catch
		// it and it would never get displayed.
		if (!asString) {
			asString = message;
			var methodName:String = ReflectUtil.getMethodName(overloadedMethod, overloadTarget);
			if (methodName) {
				asString += "\n  Overloaded Method: " + (ReflectUtil.isMethodStatic(methodName, overloadTarget) ? "static " : "") + methodName;
			} else {
				if (ReflectUtil.isConstructor(overloadedMethod, overloadTarget)) {
					asString += "\n  Overloaded Method: new";
				}
			}
			asString += "\n  Used Arguments["+overloadArguments.length+"]: ";
			for (var i:Number = 0; i < overloadArguments.length; i++) {
				if (i != 0) {
					asString += ", ";
				}
				asString += overloadArguments[i];
			}
			asString += "\n  Used Handlers: ";
			for(var i:Number = 0; i < overloadHandlers.length; i++) {
				asString += "\n    "+overloadHandlers[i].toString();
			}
		}
		return asString;
	}
	
}