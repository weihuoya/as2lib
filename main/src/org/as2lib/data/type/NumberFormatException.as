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

import org.as2lib.env.except.Exception;

/**
 * Exception to be thrown if a Number is not possible to convert into a different number.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.data.type.NumberFormatException extends Exception {
	
	/**
	 * Constructs a new NumberFormatException
	 * 
	 * @param message Message to the exception
	 * @param thrower Object that throw the exception
	 * @param args	Arguments that were available while throwing the exception
	 */
	public function NumberFormatException(message:String, thrower, args:Array) {
		super(message, thrower, args);
	}
}