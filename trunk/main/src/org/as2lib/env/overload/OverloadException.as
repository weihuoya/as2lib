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
 * OverloadException is the base Throwable of the org.as2lib.env.overload package.
 * All Throwables contained in this package extend it.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.overload.OverloadException extends FatalException {
	
	/**
	 * Constructs a new OverloadException
	 * 
	 * @param message			Message to the Exception.
	 * @param thrower			Object where the Exception occured.
	 * @param args				Arguments of the method where the exception occured.
	 */
	public function OverloadException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
}