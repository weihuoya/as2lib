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

import org.as2lib.core.BasicInterface;
import org.as2lib.data.holder.Map;
import org.as2lib.env.bean.PropertyValue;
import org.as2lib.env.bean.PropertyValueSet;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.bean.PropertyAccessor extends BasicInterface {
	
	public function getPropertyValue(propertyName:String);
	
	public function setPropertyValue():Void;
	
	public function setPropertyValueByPropertyValue(propertyValue:PropertyValue):Void;
	
	public function setPropertyValueByNameAndValue(propertyName:String, value):Void;
	
	public function setPropertyValues():Void;
	
	public function setPropertyValuesByPropertyValueSet(propertyValues:PropertyValueSet):Void;
	
	public function setPropertyValuesByMap(propertyValues:Map):Void;
	
}