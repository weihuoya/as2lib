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
import org.as2lib.util.ArrayUtil;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.bean.PropertyValueSet;
import org.as2lib.env.bean.PropertyValue;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.MutablePropertyValueSet extends BasicClass implements PropertyValueSet {
	
	/** Stores added properties. */
	private var propertyArray:Array;
	
	/**
	 * Constructs a new instance.
	 */
	public function MutablePropertyValueSet(Void) {
		propertyArray = new Array();
	}
	
	public function addPropertyValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyValue], addPropertyValueByPropertyValue);
		o.addHandler([String, Object], addPropertyValueByNameAndValue);
		o.forward(arguments);
	}
	
	public function addPropertyValueByPropertyValue(propertyValue:PropertyValue):Void {
		for (var i:Number = 0; i < propertyArray.length; i++) {
			var currentPropertyValue:PropertyValue = propertyArray[i];
			if (currentPropertyValue.getName() == propertyValue.getName()) {
				propertyArray[i] = propertyValue;
				return;
			}
		}
		propertyArray.push(propertyValue);
	}
	
	public function addPropertyValueByNameAndValue(propertyName:String, propertyValue):Void {
		addPropertyValueByPropertyValue(new PropertyValue(propertyName, propertyValue));
	}
	
	public function removePropertyValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyValue], removePropertyValueByPropertyValue);
		o.addHandler([String, Object], addPropertyValueByNameAndValue);
		o.forward(arguments);
	}
	
	public function removePropertyValueByPropertyValue(propertyValue:PropertyValue):Void {
		ArrayUtil.removeElement(propertyArray, propertyValue);
	}
	
	public function removePropertyValueByName(propertyName:String):Void {
		for (var i:Number = 0; i < propertyArray.length; i++) {
			var propertyValue:PropertyValue = propertyArray[i];
			if (propertyValue.getName() == propertyName) {
				propertyArray.splice(i, 1);
				return;
			}
		}
	}
	
	/**
	 * @see PropertyValueRepository#contains(String):Boolean
	 */
	public function contains(propertyName:String):Boolean {
		for (var i:Number = 0; i < propertyArray.length; i++) {
			var propertyValue:PropertyValue = propertyArray[i];
			if (propertyValue.getName() == propertyName) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @see PropertyValueRepository#getPropertyValue(String):PropertyValue
	 */
	public function getPropertyValue(propertyName:String):PropertyValue {
		for (var i:Number = 0; i < propertyArray.length; i++) {
			var propertyValue:PropertyValue = propertyArray[i];
			if (propertyValue.getName() == propertyName) {
				return propertyValue;
			}
		}
	}
	
	/**
	 * @see PropertyValueRepository#getPropertyValues(Void):Array
	 */
	public function getPropertyValues(Void):Array {
		return propertyArray.concat();
	}
	
	/**
	 * @see PropertyValueRepository#apply(bean):Void
	 */
	public function apply(bean):Void {
		for (var i:Number = 0; i < propertyArray.length; i++) {
			PropertyValue(propertyArray[i]).apply(bean);
		}
	}
	
}