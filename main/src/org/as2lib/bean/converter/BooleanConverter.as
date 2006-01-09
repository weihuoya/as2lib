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
class org.as2lib.bean.converter.BooleanConverter extends BasicClass implements PropertyValueConverter {
	
	public static var VALUE_TRUE:String = "true";
	public static var VALUE_FALSE:String = "false";
	
	public static var VALUE_ON:String = "on";
	public static var VALUE_OFF:String = "off";
	
	public static var VALUE_YES:String = "yes";
	public static var VALUE_NO:String = "no";
	
	public static var VALUE_1:String = "1";
	public static var VALUE_0:String = "0";
	
	public function BooleanConverter(Void) {
	}
	
	public function convertPropertyValue(value:String, type:Function) {
		if (value == "" || value == null) {
			return null;
		}
		if (type != null && type != Boolean) {
			return new type(value);
		}
		if (value == VALUE_TRUE || value == VALUE_ON || value == VALUE_YES || value == VALUE_1) {
			return true;
		}
		if (value == VALUE_FALSE || value == VALUE_OFF || value == VALUE_NO || value == VALUE_0) {
			return false;
		}
		throw new IllegalArgumentException("Invalid boolean value '" + value + "'.", this, arguments);
	}
	
}