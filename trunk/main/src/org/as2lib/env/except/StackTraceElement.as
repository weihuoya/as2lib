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

import org.as2lib.core.BasicInterface;

/**
 * StackTraceElement represents an element in the stack trace returned by
 * Throwable#getStackTrace().
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
interface org.as2lib.env.except.StackTraceElement extends BasicInterface {
	
	/**
	 * Returns the object that threw the exception.
	 *
	 * @return the object that threw the exception
	 */
	public function getThrower(Void);
	
	/**
	 * Returns the method that thew the exception.
	 *
	 * @return the method that threw the exception
	 */
	public function getMethod(Void):Function;
	
	/**
	 * Returns the arguments that have been passed to the method that threw
	 * the exception.
	 *
	 * @return the arguments passed to the method that threw the exception
	 */
	public function getArguments(Void):Array;
	
}