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
 * OverloadException is the base exception of the org.as2lib.env.overload
 * package.
 * 
 * <p>All exceptions of this package extend it.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.overload.OverloadException extends FatalException {
	
	/**
	 * Constructs a new OverloadException instance.
	 * 
	 * @param message the message of the exception
	 * @param thrower the object whose method threw the exception
	 * @param args the arguments of the method that threw the exception
	 */
	public function OverloadException(message:String, thrower, args:Array) {
		super (message, thrower, args);
	}
}