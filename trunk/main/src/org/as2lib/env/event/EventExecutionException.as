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
 * Exception as Wrapper for a exception thrown during execution of a event.
 *
 * @author Martin Heidegger
 */
class org.as2lib.env.event.EventExecutionException extends Exception {
	
	/**
	 * Constructs a new EventExecutionExceptions
	 *
	 * @param error Generic error to wrap
	 * @param message Message to the exception.
	 * @param scope Scope where the exception was thrown.
	 * @param args Arguments of the scope.
	 */
	public function EventExecutionException(error, message:String, scope, args:FunctionArguments) {
		super (message, scope, args);
		initCause(error);
	}
}