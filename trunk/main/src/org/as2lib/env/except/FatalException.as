﻿/*
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

/**
 * FatalException is a default implementation of the Throwable interface. It is
 * different from the Exception in that it marks the Throwable as fatal. Which
 * has a higher priority/level than the normal Exception.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.except.FatalException extends AbstractThrowable implements Throwable {
	
	/**
	 * Constructs a new FatalException.
	 *
	 * @see org.as2lib.env.except.AbstractThrowable#new()
	 */
	public function FatalException(message:String, thrower, args:FunctionArguments) {
		super (message, thrower, args);
	}
	
	/**
	 * Returns a blank String if the operation is not called out of an operation.
	 * This operation should only be called by the virtual machine. We use it to
	 * determine when the Exception has reached the final level and now terminates
	 * the current thread. It then uses the ExceptConfig#getOut()#fatal() operation
	 * to write out the Throwable.
	 *
	 * @return a blank String if the operation is not called out of an operation, otherwise the result of ExceptConfig#getThrowableStringifier()#execute(this) will be returned
	 */
	public function toString(Void):String {
		if (!arguments.caller) {
			ExceptConfig.getOut().fatal(this);
			return "";
		}
		return ExceptConfig.getThrowableStringifier().execute(this);
	}
	
}