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

import org.as2lib.env.except.Throwable;
import org.as2lib.env.except.AbstractThrowable;
import org.as2lib.env.except.ExceptConfig;
import org.as2lib.env.log.LoggerRepositoryManager;
import org.as2lib.env.log.Logger;

/**
 * Exception is a normal default implementation of the Throwable interface.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.except.Exception extends AbstractThrowable implements Throwable {
	
	/** Logger used to output this exception. */
	private static var logger:Logger = LoggerRepositoryManager.getRepository().getLogger("org.as2lib.env.except.Throwable");
	
	/**
	 * Constructs a new Exception.
	 *
	 * @see org.as2lib.env.except.AbstractThrowable#new()
	 */
	public function Exception(message:String, thrower, args:Array) {
		super(message, thrower, args);
	}
	
	/**
	 * Returns a blank String if the operation is not called out of an operation.
	 * This operation should only be called by the virtual machine. We use it to
	 * determine when the Exception has reached the final level and now terminates
	 * the current thread.
	 *
	 * @return a blank String if the operation is not called out of an operation, otherwise the result of ExceptConfig#getThrowableStringifier()#execute(this) will be returned
	 */
	public function toString(Void):String {
		if (!arguments.caller) {
			logger.error(this);
			return "";
		}
		return ExceptConfig.getThrowableStringifier().execute(this);
	}
	
}