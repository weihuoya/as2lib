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
import org.as2lib.env.except.StackTraceElement;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.except.StackTraceElementFactory extends BasicInterface {
	/**
	 * Returns a StackTraceElement instance.
	 *
	 * @param thrower the object that threw the Throwable
	 * @param method the operation that threw the Throwable
	 * @param args the arguments that caused the method to throw the Throwable
	 * @return a StackTraceElement instance
	 */
	public function getStackTraceElement(thrower, method:Function, args:FunctionArguments):StackTraceElement;
}