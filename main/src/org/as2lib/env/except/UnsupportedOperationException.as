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

import org.as2lib.env.except.FatalException;

/**
 * UnsupportedOperationException gets thrown to indicate that an operation
 * is not supported by the throwing class.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.except.UnsupportedOperationException extends FatalException {
	
	/**
	 * Constructs a new UnsupportedOperationException instance.
	 *
	 * <p>All arguments are allowed to be null or undefined. But if one is,
	 * the string representation returned by the #toString method is not
	 * complete anymore.
	 *
	 * <p>The args array should be the internal arguments array of the
	 * method that throws the throwable. The internal arguments array exists
	 * in every method and contains its parameters, the callee method and
	 * the caller method. You can refernce it in every method using the name
	 * 'arguments'.
	 *
	 * @param message the message that describes in detail what the problem is
	 * @param thrower the object that declares the method that throws this throwable
	 * @param args the arguments of the throwing method
	 */
	public function UnsupportedOperationException(message:String, thrower, args:Array) {
		super (message, thrower, args);
	}
	
}