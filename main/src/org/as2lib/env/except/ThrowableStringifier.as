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
import org.as2lib.util.Stringifier;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * ThrowableStringifier is used to stringify a Throwable.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.except.ThrowableStringifier extends BasicClass implements Stringifier {
	
	/**
	 * @see org.as2lib.util.string.Stringifier#execute()
	 */
	public function execute(target):String {
		var throwable:Throwable = target;
		return (ReflectUtil.getClassNameForInstance(throwable) + ": " + throwable.getMessage() + "\n"
				+ stringifyStackTrace(throwable.getStackTrace()));
	}

	/**
	 * Stringifies the passed-in stack trace.
	 *
	 * @param stackTrace the stack trace to stringify
	 * @return the string representation of the stack trace
	 */
	public function stringifyStackTrace(stackTrace:Array):String {
		var result:String = "";
		for (var i:Number = 0; i < stackTrace.length; i++) {
			var element:StackTraceElement = stackTrace[i];
			result += ("  at " 
					   + element.toString());
			if (i < stackTrace.length-1) {
				result += "\n";
			}
		}
		return result;
	}
	
}