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
import org.as2lib.env.overload.Overload;
import org.as2lib.env.bean.AbstractPropertyAccessor;
import org.as2lib.env.bean.PropertyValueConverter;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.AbstractBeanWrapper extends AbstractPropertyAccessor {
	
	public static var METHOD_PREFIX:String = "?";
	public static var PROPERTY_PREFIX:String = "&";
	
	private function AbstractBeanWrapper(Void) {
	}
	
	public function registerPropertyValueConverter():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Function, PropertyValueConverter], this["registerPropertyValueConverterByTypeAndConverter"]);
		o.addHandler([Function, String, PropertyValueConverter], this["registerPropertyValueConverterByTypeAndPathAndConverter"]);
		o.forward(arguments);
	}
	
}