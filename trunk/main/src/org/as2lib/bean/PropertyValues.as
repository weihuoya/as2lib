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

import org.as2lib.bean.Mergable;
import org.as2lib.bean.PropertyValue;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.ArrayUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyValues extends BasicClass {
	
	/** Added property values. */
	private var propertyValues:Array;
	
	public function PropertyValues(source:PropertyValues) {
		propertyValues = new Array();
		if (source != null) {
			var pvs:Array = source.getPropertyValues();
			for (var i:Number = 0; i < pvs.length; i++) {
				var pv:PropertyValue = pvs[i];
				propertyValues.push(new PropertyValue(pv.getName(), pv.getValue(), pv.getType()));
			}
		}
	}
	
	public function addPropertyValues():Void {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyValues], addPropertyValuesByPropertyValues);
		o.addHandler([Map], addPropertyValuesByMap);
		o.forward(arguments);
	}
	
	public function addPropertyValuesByPropertyValues(propertyValues:PropertyValues):Void {
		var pvs:Array = propertyValues.getPropertyValues();
		for (var i:Number = 0; i < pvs.length; i++) {
			addPropertyValueByPropertyValue(pvs[i]);
		}
	}
	
	public function addPropertyValuesByMap(source:Map):Void {
		var propertyNames:Array = source.getKeys();
		var propertyValues:Array = source.getValues();
		for (var i:Number = 0; i < propertyNames.length; i++) {
			addPropertyValueByPropertyValue(new PropertyValue(propertyNames[i], propertyValues[i]));
		}
	}
	
	public function addPropertyValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyValue], addPropertyValueByPropertyValue);
		o.addHandler([String, Object], addPropertyValueByNameAndValueAndType);
		o.addHandler([String, Object, Function], addPropertyValueByNameAndValueAndType);
		o.forward(arguments);
	}
	
	public function addPropertyValueByPropertyValue(propertyValue:PropertyValue):Void {
		for (var i:Number = 0; i < propertyValues.length; i++) {
			var currentPropertyValue:PropertyValue = propertyValues[i];
			if (currentPropertyValue.getName() == propertyValue.getName()) {
				mergeIfRequired(propertyValue, currentPropertyValue);
				propertyValues[i] = propertyValue;
				return;
			}
		}
		propertyValues.push(propertyValue);
	}
	
	/**
	 * Merges the value of the supplied 'new' {@link PropertyValue} with that of
	 * the current {@link PropertyValue} if merging is supported and enabled.
	 * @see Mergable
	 */
	private function mergeIfRequired(newPropertyValue:PropertyValue, currentPropertyValue:PropertyValue):Void {
		var value = newPropertyValue.getValue();
		if (value instanceof Mergable) {
			var mergable:Mergable = value;
			if (mergable.isMergeEnabled()) {
				mergable.merge(currentPropertyValue.getValue());
			}
		}
	}
	
	public function addPropertyValueByNameAndValueAndType(propertyName:String, propertyValue, propertyType:Function):Void {
		addPropertyValueByPropertyValue(new PropertyValue(propertyName, propertyValue, propertyType));
	}
	
	public function removePropertyValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyValue], removePropertyValueByPropertyValue);
		o.addHandler([String], removePropertyValueByName);
		o.forward(arguments);
	}
	
	public function removePropertyValueByPropertyValue(propertyValue:PropertyValue):Void {
		ArrayUtil.removeElement(propertyValues, propertyValue);
	}
	
	public function removePropertyValueByName(propertyName:String):Void {
		removePropertyValueByPropertyValue(getPropertyValue(propertyName));
	}
	
	public function contains(propertyName:String):Boolean {
		return (getPropertyValue(propertyName) != null);
	}
	
	public function getPropertyValue(propertyName:String):PropertyValue {
		for (var i:Number = 0; i < propertyValues.length; i++) {
			var propertyValue:PropertyValue = propertyValues[i];
			if (propertyValue.getName() == propertyName) {
				return propertyValue;
			}
		}
		return null;
	}
	
	public function getPropertyValues(Void):Array {
		return propertyValues.concat();
	}
	
	public function isEmpty(Void):Boolean {
		return (propertyValues.length == 0);
	}
	
}