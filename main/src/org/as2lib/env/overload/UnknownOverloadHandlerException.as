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

/**
 * UnknownOverloadHandlerException will be thrown if no appropriate OverloadHandler
 * could be found.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.env.overload.UnknownOverloadHandlerException extends OverloadException {
	
	/** Arguments used by overloading */
	private var overloadArguments:FunctionArguments;
	
	/** Handlers that where available by the unknown overloadHandler */
	private var handlers:Array;
	
	/** Exception printed as string */
	private var asString:String;
	
	/**
	 * Constructs a new OverloadException
	 * 
	 * @param message			Message to the Exception.
	 * @param thrower			Object where the Exception occured.
	 * @param args				Arguments of the method where the exception occured.
	 * @param handlers			Available Handlers due to the unhandable exception.
	 */
	public function UnknownOverloadHandlerException(message:String, thrower, args:FunctionArguments, handlers:Array) {
		super (message, thrower, args);
		this.handlers = handlers;
		this.overloadArguments = args;
	}
	
	/**
	 * Extended toString method that displayes the content of this exception lacy.
	 * 
	 * @return Exception as string.
	 */
	public function toString():String {
		
		// Lacy construction of the string,
		// Because it takes pretty much time to construct it (using Reflections)
		// it would take unnecessary much time to construct it if you catch it (and it
		// won't be displayed).
		if(!asString) {
			asString = message;
			asString += "\n  Used Arguments["+overloadArguments.length+"]: ";
			for(var i:Number = 0; i < overloadArguments.length; i++) {
				if(i != 0) {
					asString += ", ";
				}
				asString += overloadArguments[i];
			}
			asString += ";\n  Available Handlers: ";
			for(var i:Number = 0; i < handlers.length; i++) {
				asString += "\n    "+handlers[i].toString();
			}
		}
		return asString;
	}
}