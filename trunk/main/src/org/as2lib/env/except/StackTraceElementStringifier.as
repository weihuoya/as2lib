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
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.StringUtil;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;

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
		var result:String = "";
		var element:StackTraceElement = StackTraceElement(target);
		
		var throwerName:String = element.getThrower().getName();
		if (throwerName == undefined) {
			throwerName = "[not evaluateable]";
		}
		
		try {
			var method:MethodInfo = element.getMethod();
			
			var methodName:String = method.getName();
			if (methodName == undefined) {
				methodName = "[not evaluateable]";
			}
			result += method.isStatic() ? "[static] " : "";
			
		} catch(e:org.as2lib.env.except.IllegalArgumentException) {
			var methodName:String = "["+method+"]";
		}
		
		result += throwerName;
		result += "." + methodName;
		result += "(" + element.getArguments() + ")";
	
		return result;
	}
	
}