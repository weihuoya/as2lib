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
 * Exception is a normal default implementation of the Throwable interface.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.except.Exception extends AbstractThrowable implements Throwable {
	
	/**
	 * Constructs a new Exception.
	 *
	 * @see org.as2lib.env.except.AbstractThrowable#new()
	 */
	public function Exception(message:String, thrower, args:Array) {
		super(message, thrower, args);
	}
	
	/**
	 * Returns a string representation of this exception.
	 *
	 * <p>If you do not call this method out of another method, it also
	 * executes the logger's error-method passing this because it thinks
	 * that the virtual machine called this method.
	 *
	 * @return a string representation of this exception
	 */
	public function toString(Void):String {
		if (!arguments.caller && getLogger()) {
			getLogger().error(this);
		}
		return ExceptConfig.getThrowableStringifier().execute(this);
	}
	
}