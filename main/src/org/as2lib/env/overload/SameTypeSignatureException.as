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
import org.as2lib.env.reflect.ClassInfo;

/**
 * SameTypeSignatureException is thrown when two or more OverloadHandlers have
 * the same type signature pending on the passed arguments.
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
	 * @see org.as2lib.env.overload.OverloadException#Constructor()
	 */
	public function SameTypeSignatureException(message:String, thrower, args:Array, overloadTarget, overloadedMethod:Function, overloadArguments:Array, overloadHandlers:Array) {
		super (message, thrower, args);
		this.overloadTarget = overloadTarget;
		this.overloadedMethod = overloadedMethod;
		this.overloadArguments = overloadArguments;
		this.overloadHandlers = overloadHandlers;
	}
	
	/**
	 * Extended toString method that displayes the content of this exception lazy.
	 * 
	 * @return Exception as string.
	 */
	public function toString(Void):String {
		// Lazy construction of the string,
		// Because it takes pretty much time to construct it (using Reflections)
		// it would take unnecessary much time to construct it if you catch it (and it
		// won't be displayed).
		if (!asString) {
			asString = message;
			try {
				var classInfo:ClassInfo = ClassInfo.forObject(overloadTarget);
				asString += "\n  Overloaded Method: " + classInfo.getMethodByMethod(overloadedMethod);
			} catch (e) {
				if (classInfo.getConstructor().getMethod() == overloadedMethod) {
					asString += "\n  Overloaded Method: " + classInfo.getConstructor();
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