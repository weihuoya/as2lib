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
import org.as2lib.env.except.Throwable;
import org.as2lib.env.except.StackTraceElement;

/**
 * Generic exception to wrap any Object to a exception.
 * Macromedia supports throwing of objects of any type. If you want to use a catched
 * thrown object to be the initCause of a exception you can use this class to wrap the
 * object.
 * If the object to wrap is a implementation of Throwable it will take all the content
 * of the object(Stacktrace,Message,...), in any other case it will take the String representation
 * of the object as message.
 *
 * @author Martin Heidegger
 */
class org.as2lib.env.except.WrapperException extends Exception {
	
	/**
	 * Constructs a new ErrorWrapperException
	 *
	 * @param e Generic error to be wrapped
	 * @param message Message to the exception.
	 * @param scope Scope where the exception was thrown.
	 * @param args Arguments of the scope.
	 */
	public function WrapperException(e, message:String, scope, args) {
		super(message, scope, args);
		if(e instanceof Throwable) {
			initCause(e);
		} else {
			initCause(new Exception(e.toString(), this, arguments));
		}
	}
}