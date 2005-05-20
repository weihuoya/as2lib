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

/**
 * {@code MethodInvocation} reflects a profiled method invocation.
 * 
 * @author Simon Wacker */
class org.as2lib.test.speed.MethodInvocation extends BasicClass {
	
	/** Time needed for this method invocation. */
	private var time:Number;
	
	/** Arguments used for this method invocation. */
	private var args:Array;
	
	/** Return value of this method invocation. */
	private var returnValue;
	
	/** Exception thrown during this method invocation. */
	private var exception;
	
	/**
	 * Constructs a new {@code MethodInvocation} instance.
	 * 
	 * @param time the needed time for this method invocation
	 * @param args the arguments used for this method invocation	 */
	public function MethodInvocation(time:Number, args:Array) {
		this.time = time;
		this.args = args;
	}
	
	/**
	 * Returns the time needed for this method invocation.
	 * 
	 * @return the time needed for this method invocation	 */
	public function getTime(Void):Number {
		return this.time;
	}
	
	/**
	 * Returns the arguments used for this method invocation.
	 * 
	 * @return the arguments used for this method invocation	 */
	public function getArguments(Void):Array {
		return this.args;
	}
	
	/**
	 * Returns this method invocation's return value.
	 * 
	 * @return this method invocation's return value	 */
	public function getReturnValue(Void) {
		return this.returnValue;
	}
	
	/**
	 * Sets the return value of this method invocation.
	 * 
	 * @param returnValue the return value of this method invocation	 */
	public function setReturnValue(returnValue):Void {
		this.exception = undefined;
		this.returnValue = returnValue;
	}
	
	/**
	 * Returns the exception thrown during this method invocation.
	 * 
	 * @return the exception thrown during this method invocation	 */
	public function getException(Void) {
		return this.exception;
	}
	
	/**
	 * Sets the exception thrown during this method invocation.
	 * 
	 * @param exception the exception thrown during this method invocation	 */
	public function setException(exception):Void {
		this.returnValue = undefined;
		this.exception = exception;
	}
	
	/**
	 * Returns whether this method invocation was successful. Successful means that it
	 * returned a proper return value and did not throw an exception.	 */
	public function wasSuccessful(Void):Boolean {
		return (this.exception === undefined);
	}
	
}