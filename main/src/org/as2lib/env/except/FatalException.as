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

/**
 * FatalException is a default implementation of the Throwable interface. It is
 * different from the Exception in that it marks the Throwable as fatal. Which
 * has a fatality than the normal Exception.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.except.FatalException extends AbstractThrowable implements Throwable {
	
	/**
	 * Constructs a new FatalException.
	 *
	 * @see org.as2lib.env.except.AbstractThrowable#new()
	 */
	public function FatalException(message:String, thrower, args:Array) {
		super (message, thrower, args);
	}
	
	/**
	 * Returns a string representation of this fatal exception.
	 *
	 * <p>If you do not call this method out of another method, it also
	 * executes the logger's fatal-method passing this because it thinks
	 * that the virtual machine called this method.
	 *
	 * @return a string representation of this fatal exception
	 */
	public function toString(Void):String {
		if (!arguments.caller && getLogger()) {
			getLogger().fatal(this);
		}
		return ExceptConfig.getThrowableStringifier().execute(this);
	}
	
}