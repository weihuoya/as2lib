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
import org.as2lib.env.except.StackTraceElement;

/**
 * Simple implementation of the StackTraceElement interface.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.env.except.SimpleStackTraceElement extends BasicClass implements StackTraceElement {
	
	/** The thrower. */
	private var thrower;
	
	/** The throwing method. */
	private var method:Function;
	
	/** The arguments passed to the throwing method. */
	private var args:Array;
	
	/**
	 * Constructs a new SimpleStackTraceElement instance.
	 * 
	 * @param thrower the class that threw the Throwable
	 * @param method the method that threw the Throwabele
	 * @param args the arguments passed to the throwing method
	 */
	public function SimpleStackTraceElement(thrower, method:Function, args:Array) {
		this.thrower = thrower ? thrower : null;
		this.method = method ? method : null;
		this.args = args ? args : null;
	}
	
	/**
	 * @see org.as2lib.env.except.StackTraceElement#getThrower()
	 */
	public function getThrower(Void) {
		return thrower;
	}
	
	/**
	 * @see org.as2lib.env.except.StackTraceElement#getMethod()
	 */
	public function getMethod(Void):Function {
		return method;
	}
	
	/**
	 * @see org.as2lib.env.except.StackTraceElement#getArguments()
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