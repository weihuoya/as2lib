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
import org.as2lib.env.except.StackTraceElementFactory;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.except.SimpleStackTraceElement;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.except.SimpleStackTraceElementFactory extends BasicClass implements StackTraceElementFactory {
	/**
	 * @see org.as2lib.env.except.StackTraceElementFactory#getStackTraceElement()
	 */
	public function getStackTraceElement(thrower, method:Function, args:FunctionArguments):StackTraceElement {
		return new SimpleStackTraceElement(thrower, method, args);
	}
}