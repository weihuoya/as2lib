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
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ClassInfo;

/**
 * UnknownOverloadHandlerException will be thrown if no appropriate OverloadHandler
 * could be found.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.env.overload.UnknownOverloadHandlerException extends OverloadException {
	
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
	 * Constructs a new OverloadException
	 * 
	 * @param message			Message to the Exception.
	 * @param thrower			Object where the Exception occured.
	 * @param args				Arguments of the method where the exception occured.
	 * @param overloadTarget	The target object on which the overload is perfomred.
	 * @param overloadedMethod	The method that gets overlaoded.
	 * @param overloadArguments	The arguments used for the overloading.
	 * @param overloadHandlers	The available handlers that do not match.
	 */
	public function UnknownOverloadHandlerException(message:String, thrower, args:FunctionArguments, overloadTarget, overloadedMethod:Function, overloadArguments:Array, overloadHandlers:Array) {
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
	public function toString():String {
		// Lazy construction of the string,
		// Because it takes pretty much time to construct it (using Reflections)
		// it would take unnecessary much time to construct it if you catch it (and it
		// won't be displayed).
		if (!asString) {
			asString = getMessage();
			try {
				var classInfo:ClassInfo = ReflectUtil.getClassInfo(overloadTarget);
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
			asString += "\n  Available Handlers: ";
			for(var i:Number = 0; i < overloadHandlers.length; i++) {
				asString += "\n    "+overloadHandlers[i].toString();
			}
		}
		return asString;
	}
}