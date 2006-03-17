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

import org.as2lib.bean.Mergeable;
import org.as2lib.bean.PropertyValue;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.ArrayUtil;

/**
 * {@code PropertyValues} holds 0 or more property values.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyValues extends BasicClass {
	
	/** Added property values. */
	private var propertyValues:Array;
	
	/**
	 * Constructs a new {@code PropertyValues} instance.
	 * 
	 * <p>If the given {@code source} is not {@code null} its property values will
	 * be copied to this new instance. Note that populating on construction is faster
	 * than populating via {@link #addPropertyValues} because duplicate entries must
	 * not be checked.
	 * 
	 * @param source the property values to populate this instance with
	 */
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
	
	/**
	 * Populates this instance with the given property values.
	 * 
	 * <p>Note that populating on construction is faster because duplicate entries
	 * must not be checked there.
	 * 
	 * @param propertyValues the property values to populate this instance with
	 */
	public function addPropertyValues(propertyValues:PropertyValues):Void {
		var pvs:Array = propertyValues.getPropertyValues();
		for (var i:Number = 0; i < pvs.length; i++) {
			addPropertyValueByPropertyValue(pvs[i]);
		}
	}
	
	/**
	 * @overload #addPropertyValueByPropertyValue
	 * @overload #addPropertyValueByNameAndValueAndType
	 */
	public function addPropertyValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyValue], addPropertyValueByPropertyValue);
		o.addHandler([String, Object], addPropertyValueByNameAndValueAndType);
		o.addHandler([String, Object, Function], addPropertyValueByNameAndValueAndType);
		o.forward(arguments);
	}
	
	/**
	 * Adds the given {@code propertyValue}, merging its value if there is already a
	 * property value for the same property name and the value implements the
	 * {@link Mergeable} interface.
	 * 
	 * @param propertyValue the property value to add
	 */
	public function addPropertyValueByPropertyValue(propertyValue:PropertyValue):Void {
		var propertyName:String = propertyValue.getName();
		if (propertyValues[propertyName]) {
			for (var i:Number = 0; i < propertyValues.length; i++) {
				var currentPropertyValue:PropertyValue = propertyValues[i];
				if (currentPropertyValue.getName() == propertyName) {
					if (mergeIfRequired(propertyValue, currentPropertyValue)) {
						propertyValues[i] = propertyValue;
						return;
					}
				}
			}
		}
		else {
			propertyValues[propertyName] = true;
		}
		propertyValues.push(propertyValue);
	}
	
	/**
	 * Merges the value of the supplied {@code newPropertyValue} with that of the
	 * {@code currentPropertyValue} if merging is supported and enabled.
	 * 
	 * @param newPropertyValue the new property value to merge if required
	 * @param currentPropertyValue the current property value
	 * @return {@code true} if merge was required else {@code false}
	 * @see Mergeable
	 */
	private function mergeIfRequired(newPropertyValue:PropertyValue, currentPropertyValue:PropertyValue):Boolean {
		var value = newPropertyValue.getValue();
		if (value instanceof Mergeable) {
			var mergable:Mergeable = value;
			if (mergable.isMergeEnabled()) {
				mergable.merge(currentPropertyValue.getValue());
			}
			return true;
		}
		return false;
	}
	
	/**
	 * Adds a new property value for the property with the given name.
	 * 
	 * <p>If there is already a property value with the given name, the given value
	 * is merged with the current value, if the given value implements the {@link Mergeable}
	 * interface.
	 * 
	 * @param propertyName the name of the property
	 * @param propertyValue the value to set for the property
	 * @param propertyType the type to convert the value to
	 */
	public function addPropertyValueByNameAndValueAndType(propertyName:String, propertyValue, propertyType:Function):Void {
		addPropertyValueByPropertyValue(new PropertyValue(propertyName, propertyValue, propertyType));
	}
	
	/**
	 * @overload #removePropertyValueByPropertyValue
	 * @overload #removePropertyValueByName
	 */
	public function removePropertyValue():Void {
		var o:Overload = new Overload(this);
		o.addHandler([PropertyValue], removePropertyValueByPropertyValue);
		o.addHandler([String], removePropertyValueByName);
		o.forward(arguments);
	}
	
	/**
	 * Removes the given property value. The given property value must be an instance
	 * added to this list.
	 * 
	 * @param propertyValue the property value to remove
	 */
	public function removePropertyValueByPropertyValue(propertyValue:PropertyValue):Void {
		ArrayUtil.removeElement(propertyValues, propertyValue);
	}
	
	/**
	 * Removes the property value with the given name.
	 * 
	 * @param propertyName the name of the property to remove
	 */
	public function removePropertyValueByName(propertyName:String):Void {
		removePropertyValueByPropertyValue(getPropertyValue(propertyName));
	}
	
	/**
	 * Checks whether this list contains a property with the given name.
	 * 
	 * @param propertyName the name of the property to check for existence
	 * @return {@code true} if there is a property value with the given name, else
	 * {@code false}
	 */
	public function contains(propertyName:String):Boolean {
		return (propertyValues[propertyName] == true);
	}
	
	/**
	 * Returns the property value for the given name.
	 * 
	 * @param propertyName the name of the property to return the value for
	 * @return the property value for the given name or {@code null} if none
	 */
	public function getPropertyValue(propertyName:String):PropertyValue {
		for (var i:Number = 0; i < propertyValues.length; i++) {
			var propertyValue:PropertyValue = propertyValues[i];
			if (propertyValue.getName() == propertyName) {
				return propertyValue;
			}
		}
		return null;
	}
	
	/**
	 * Returns all {@code PropertyValue} instances added to this list.
	 * 
	 * @return all added property values
	 */
	public function getPropertyValues(Void):Array {
		return propertyValues;
	}
	
	/**
	 * Checks whether this list contains any property values.
	 * 
	 * @return {@code true} if no properties are added else {@code false}
	 */
	public function isEmpty(Void):Boolean {
		return (propertyValues.length == 0);
	}
	
}