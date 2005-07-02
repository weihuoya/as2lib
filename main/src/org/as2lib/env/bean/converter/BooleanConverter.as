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

import org.as2lib.env.bean.AbstractPropertyValueConverter;
import org.as2lib.env.bean.PropertyValueConverter;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.converter.BooleanConverter extends AbstractPropertyValueConverter implements PropertyValueConverter {
	
	public function BooleanConverter(Void) {
	}
	
	public function convertPropertyValueByStringValue(value:String) {
		if (value == "true" || value == "1") return true;
		if (value == "false" || value == "0") return false;
		return Boolean(value);
	}
	
	public function convertPropertyValueByStringValueAndType(value:String, type:Function) {
		if (type && type != Boolean) {
			return new type(value);
		}
		return convertPropertyValueByStringValue(value);
	}
	
}