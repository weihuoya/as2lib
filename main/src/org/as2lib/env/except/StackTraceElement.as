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
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;

/**
 * StackTraceElement represents an element in the stack trace returned by
 * Throwable#getStackTrace().
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
interface org.as2lib.env.except.StackTraceElement extends BasicInterface {
	/**
	 * Returns a ClassInfo representing the class that has thrown the Throwable.
	 *
	 * @return a ClassInfo representing the throwing class
	 */
	public function getThrower(Void):ClassInfo;
	
	/**
	 * Returns the method in form of a MethodInfo that threw the Throwable.
	 *
	 * @return the method that threw the Throwable
	 */
	public function getMethod(Void):MethodInfo;
	
	/**
	 * Returns the arguments that have been passed to the throwing method.
	 * NOTE: This method will be removed as soon as it is possible to determine
	 * the arguments types a method takes.
	 *
	 * @return the passed arguments
	 */
	public function getArguments(Void):FunctionArguments;
}