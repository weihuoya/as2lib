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

import org.as2lib.core.BasicClass;
import org.as2lib.env.except.ExceptConfig;

/**
 * StackTraceElement represents an element in the stack trace returned by
 * Throwable#getStackTrace().
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.env.except.StackTraceElement extends BasicClass {
	
	/** The thrower. */
	private var thrower;
	
	/** The throwing method. */
	private var method:Function;
	
	/** The arguments passed to the throwing method. */
	private var args:Array;
	
	/**
	 * Constructs a new SimpleStackTraceElement instance.
	 * 
	 * @param thrower the class that threw the throwable
	 * @param method the method that threw the throwabele
	 * @param args the arguments passed to the throwing method
	 */
	public function StackTraceElement(thrower, method:Function, args:Array) {
		this.thrower = thrower ? thrower : null;
		this.method = method ? method : null;
		this.args = args ? args : null;
	}
	
	/**
	 * Returns the object that threw the exception.
	 *
	 * @return the object that threw the exception
	 */
	public function getThrower(Void) {
		return thrower;
	}
	
	/**
	 * Returns the method that threw the exception.
	 *
	 * @return the method that threw the exception
	 */
	public function getMethod(Void):Function {
		return method;
	}
	
	/**
	 * Returns the arguments that have been passed to the method that threw
	 * the exception.
	 *
	 * @return the arguments passed to the method that threw the exception
	 */
	public function getArguments(Void):Array {
		return args;
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return ExceptConfig.getStackTraceElementStringifier().execute(this);
	}
	
}