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

import org.as2lib.bean.PropertyValueConverter;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.converter.NumberConverter extends BasicClass implements PropertyValueConverter {
	
	public static var VALUE_TRUE:String = "true";
	public static var VALUE_FALSE:String = "false";
	
	public function NumberConverter(Void) {
	}
	
	public function convertPropertyValue(value:String, type:Function) {
		if (value == "" || value == null) {
			return null;
		}
		if (type != null && type != Number) {
			return new type(value);
		}
		if (value == VALUE_TRUE) {
			return 1;
		}
		if (value == VALUE_FALSE) {
			return 0;
		}
		if (!isNaN(value)) {
			return Number(value);
		}
		throw new IllegalArgumentException("Invalid number value '" + value + "'.", this, arguments);
	}
	
}