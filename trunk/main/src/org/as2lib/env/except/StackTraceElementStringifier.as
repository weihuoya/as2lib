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
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.reflect.ReflectUtil;

/**
 * StackTraceElementStringifier is used to stringify StackTraceElements.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.env.except.StackTraceElementStringifier extends BasicClass implements Stringifier {
	
	/**
	 * @see org.as2lib.util.string.Stringifier#execute()
	 */
	public function execute(target):String {
		var element:StackTraceElement = target;
		var result:String = "";
		var thrower = element.getThrower();
		var method:Function = element.getMethod();
		
		var throwerName:String = ReflectUtil.getTypeName(thrower);
		if (throwerName == null) {
			throwerName = "[unknown]";
		}
		
		var methodName:String;
		if ((method == thrower || method == thrower.__constructor__) && thrower && method) {
			// source string 'new' out, to a constant
			methodName = "new";
		} else {
			methodName = ReflectUtil.getMethodName(method, thrower);
			if (methodName == null) {
				methodName = "[unknown]";
			}
		}
		result += ReflectUtil.isMethodStatic(methodName, thrower) ? "static " : "";
		
		result += throwerName;
		result += "." + methodName;
		result += "(" + (element.getArguments().toString() ? element.getArguments().toString() : "[unknown]") + ")";
	
		return result;
	}
	
}