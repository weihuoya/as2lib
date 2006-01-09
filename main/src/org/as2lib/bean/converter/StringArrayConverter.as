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

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.converter.StringArrayConverter extends BasicClass implements PropertyValueConverter {
	
	public static var DEFAULT_SEPARATOR:String = ",";
	
	private var separator:String;
	
	public function StringArrayConverter(separator:String) {
		if (separator == null) {
			separator = DEFAULT_SEPARATOR;
		}
		this.separator = separator;
	}
	
	public function convertPropertyValue(value:String, type:Function) {
		if (value == null) {
			return null;
		}
		if (type != null && type != Array) {
			var array:Array = new type();
			if (value != "") {
				var values:Array = value.split(separator);
				for (var i:Number = 0; i < values.length; i++) {
					array.push(values[i]);
				}
			}
			return array;
		}
		if (value != "") {
			return value.split(separator);
		}
		return new Array();
	}
	
}