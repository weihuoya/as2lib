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

import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValueConverter;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicInterface;

/**
 * @author Simon Wacker
 */
interface org.as2lib.bean.BeanWrapper extends BasicInterface {
	
	public function isWritableProperty(propertyName:String):Boolean;
	public function isReadableProperty(propertyName:String):Boolean;
	public function getPropertyValue(propertyName:String);
	public function setPropertyValue(propertyValue:PropertyValue):Void;
	public function setPropertyValues(propertyValues:PropertyValues, ignoreUnknown:Boolean):Void;
	public function findPropertyValueConverter(requiredType:Function, propertyPath:String):PropertyValueConverter;
	public function registerPropertyValueConverter():Void;
	public function registerPropertyValueConverterForType(requiredType:Function, propertyValueConverter:PropertyValueConverter):Void;
	public function registerPropertyValueConverterForProperty(requiredType:Function, propertyPath:String, propertyValueConverter:PropertyValueConverter):Void;
	public function getWrappedBean(Void);
	public function setWrappedBean(wrappedBean):Void;
	
}