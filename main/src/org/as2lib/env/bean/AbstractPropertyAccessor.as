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
import org.as2lib.data.holder.Map;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.bean.PropertyValue;
import org.as2lib.env.bean.PropertyValueSet;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.AbstractPropertyAccessor extends BasicClass {
	
	public static var NESTED_PROPERTY_SEPARATOR:String = ".";
	
	public static var PROPERTY_KEY_PREFIX:String = "[";
	
	public static var PROPERTY_KEY_SUFFIX:String = "]";
	
	/*public static var ARRAY_PREFIX:String = "array:";
	
	public static var MAP_PREFIX:String = "map:";
	
	public static var LIST_PREFIX:String = "list:";
	
	public static var QUEUE_PREFIX:String = "queue:";
	
	public static var STACK_PREFIX:String = "stack:";
	
	public static var NUMBER_PREFIX:String = "number:";
	
	public static var STRING_PREFIX:String = "string:";
	
	public static var BOOLEAN_PREFIX:String = "boolean:";
	
	public static var RGB_COLOR_PREFIX:String = "rgb:";
	
	public static var CLASS_PREFIX:String = "class:";
	
	public static var FILE_PREFIX:String = "file:";
	
	public static var LOCALE_PREFIX:String = "locale:";
	
	public static var URL_PREFIX:String = "url:";
	
	public static var DATE_PREFIX:String = "date:";
	
	public static var PROPERTIES_PREFIX:String = "properties:";*/

	private function AbstractPropertyAccessor(Void) {
	}
	
	public function setPropertyValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyValue], this["setPropertyValueByPropertyValue"]);
		o.addHandler([String, Object], this["setPropertyValueByNameAndValue"]);
		o.forward(arguments);
	}
	
	public function setPropertyValues():Void {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyValueSet], this["setPropertyValuesByPropertyValueSet"]);
		o.addHandler([Map], this["setPropertyValuesByMap"]);
		o.forward(arguments);
	}
	
}