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
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.PropertyInfo;

/**
 * PropertyInfoStringifier is used to stringify PropertyInfos.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.string.PropertyInfoStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.util.string.Stringifier#execute()
	 */
	public function execute(target):String {
		var property:PropertyInfo = PropertyInfo(target);
		var result:String = "";
		if (property.isStatic()) {
			result += "static ";
		}
		result += property.getDeclaringType().getFullName();
		result += "." + property.getName();
		return result;
	}
}