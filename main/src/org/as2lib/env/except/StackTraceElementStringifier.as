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
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.PropertyInfo;

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
		
		var thrower:ClassInfo = ClassInfo.forObject(element.getThrower());
		var throwerName:String = thrower.getFullName();
		if (throwerName == undefined) {
			throwerName = "[unknown]";
		}
		
		var method:MethodInfo = getMethod(thrower, element.getMethod());
		
		var methodName:String = method.getName();
		if (methodName == undefined) {
			methodName = "[unknown]";
		}
		result += method.isStatic() ? "static " : "";
		
		result += throwerName;
		result += "." + methodName;
		result += "(" + (element.getArguments() ? element.getArguments() : "[unknown]") + ")";
	
		return result;
	}
	
	private function getMethod(thrower:ClassInfo, method:Function) {
		if (!thrower || !method) return null;
		if (thrower.getConstructor().getMethod() == method) {
			return thrower.getConstructor();
		}
		var tempMethod:MethodInfo = thrower.getMethod(method);
		if (tempMethod) return tempMethod;
		var tempProperty:PropertyInfo = thrower.getProperty(method);
		if (tempProperty) {
			if (tempProperty.getGetter().getMethod() == method) {
				return tempProperty.getGetter().getMethod();
			}
			if (tempProperty.getSetter().getMethod() == method) {
				return tempProperty.getSetter().getMethod()
			}
		}
		return null;
	}
	
}