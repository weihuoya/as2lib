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
import org.as2lib.env.reflect.MethodInfo;

/**
 * MethodInfoStringifier stringifies MethodInfo instances.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.string.MethodInfoStringifier extends BasicClass implements Stringifier {
	
	/**
	 * Returns a string representation of the passed-in MethodInfo
	 * instance.
	 *
	 * <p>The string representation is composed as follows:
	 * [fullQualifiedDeclaringTypeName].[methodName]()
	 * or if static:
	 * static [fullQualifiedDeclaringTypeName].[methodName]()
	 *
	 * @param target an instance of type MethodInfo that shall be stringified
	 * @return the string representation of the passed-in method info
	 */
	public function execute(target):String {
		var method:MethodInfo = MethodInfo(target);
		var result:String = "";
		if (method.isStatic()) {
			result += "static ";
		}
		result += method.getDeclaringType().getFullName();
		result += "." + method.getName() + "()";
		return result;
	}
	
}