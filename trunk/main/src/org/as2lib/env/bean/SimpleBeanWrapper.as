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
import org.as2lib.util.StringUtil;
import org.as2lib.util.ClassUtil;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.bean.BeanWrapper;
import org.as2lib.env.bean.AbstractBeanWrapper;
import org.as2lib.env.bean.PropertyValue;
import org.as2lib.env.bean.PropertyValueSet;
import org.as2lib.env.bean.MutablePropertyValueSet;
import org.as2lib.env.bean.PropertyValueConverter;
import org.as2lib.env.bean.PropertyValueConverterHolder;
import org.as2lib.env.bean.FatalBeanException;
import org.as2lib.env.bean.converter.*;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.bean.SimpleBeanWrapper extends AbstractBeanWrapper implements BeanWrapper {
	
	private var wrappedObject;
	private var propertyValueConverters:Map;

	public function SimpleBeanWrapper(wrappedObject) {
		setWrappedObject(wrappedObject);
		propertyValueConverters = new HashMap();
		registerPropertyValueConverterByTypeAndPathAndConverter(Number, null, new NumberConverter());
		registerPropertyValueConverterByTypeAndPathAndConverter(Boolean, null, new BooleanConverter());
		registerPropertyValueConverterByTypeAndPathAndConverter(Function, null, new ClassConverter());
		registerPropertyValueConverterByTypeAndPathAndConverter(Array, null, new StringArrayConverter());
	}
	
	public function getPropertyValue(propertyName:String) {
		var transformedPropertyName = transformPropertyName(propertyName);
		if (propertyName.indexOf(PROPERTY_PREFIX) == 0) {
			/*if (isNestedProperty(transformedPropertyName)) {
				return getPropertyValueByPropertyAccess(getNestedObjectByPropertyAccess(transformedPropertyName), getFinalPropertyName(transformedPropertyName), getKeyName(transformedPropertyName));
			}*/
			return getPropertyValueByPropertyAccess(getWrappedObject(), getFinalPropertyName(transformedPropertyName), getKeyName(transformedPropertyName));
		}
		if (propertyName.indexOf(METHOD_PREFIX) == 0) {
			return getPropertyValueByMethodAccess(getWrappedObject(), getFinalPropertyName(transformedPropertyName), getKeyName(transformedPropertyName));
		}
		return getPropertyValueByMethodAccess(getWrappedObject(), "get"+getFinalPropertyName(transformedPropertyName), getKeyName(transformedPropertyName));
	}
	
	private function getPropertyValueByPropertyAccess(object, propertyName:String, keyName:String) {
		try {
			if (keyName) {
				return object[propertyName][keyName];
			}
			return object[propertyName];
		} catch (unknownException) {
			// wrap and rethrow exception?
			throw unknownException;
		}
	}
	
	/*private function getNestedObjectByPropertyAccess(propertyPath:String) {
		var path:String = propertyPath.substring(0, propertyPath.lastIndexOf(NESTED_PROPERTY_SEPARATOR));
		return eval("this.wrappedObject." + path);
	}*/
	
	private function getPropertyValueByMethodAccess(object, methodName:String, keyName:String) {
		if (!object[methodName]) {
			throw new FatalBeanException("Method with name '" + methodName + "' does not exist in object '" + object + "'.", this, arguments);
		}
		try {
			if (keyName) {
				if (isNaN(keyName)) {
					return object[methodName](keyName);
				} else {
					return object[methodName](Number(keyName));
				}
			}
			return object[methodName]();
		} catch (unknownException) {
			// wrap and rethrow exception?
			throw unknownException;
		}
	}

	public function setPropertyValueByPropertyValue(propertyValue:PropertyValue):Void {
		var transformedPropertyName = transformPropertyName(propertyValue.getName());
		if (propertyValue.getName().indexOf(PROPERTY_PREFIX) == 0) {
			setPropertyValueByPropertyAccess(getWrappedObject(), getFinalPropertyName(transformedPropertyName), getKeyName(transformedPropertyName), transformPropertyValue(propertyValue));
			return;
		}
		if (propertyValue.getName().indexOf(METHOD_PREFIX) == 0) {
			setPropertyValueByMethodAccess(getWrappedObject(), getFinalPropertyName(transformedPropertyName), getKeyName(transformedPropertyName), transformPropertyValue(propertyValue));
			return;
		}
		setPropertyValueByMethodAccess(getWrappedObject(), "set"+getFinalPropertyName(transformedPropertyName), getKeyName(transformedPropertyName), transformPropertyValue(propertyValue));
	}
	
	private function setPropertyValueByPropertyAccess(object, propertyName, keyName, propertyValue):Void {
		try {
			if (keyName) {
				object[propertyName][keyName] = propertyValue;
			} else {
				object[propertyName] = propertyValue;
			}
		} catch (unknownException) {
			throw unknownException;
		}
	}
	
	private function setPropertyValueByMethodAccess(object, methodName, keyName, propertyValue):Void {
		if (!object[methodName]) {
			throw new FatalBeanException("Method with name '" + methodName + "' does not exist in object '" + object + "'.", this, arguments);
		}
		try {
			if (keyName) {
				if (isNaN(keyName)) {
					object[methodName](keyName, propertyValue);
				} else {
					object[methodName](Number(keyName), propertyValue);
				}
			} else {
				object[methodName](propertyValue);
			}
		} catch (unknownException) {
			throw unknownException;
		}
	}
	
	public function setPropertyValueByNameAndValue(propertyName:String, value):Void {
		setPropertyValueByPropertyValue(new PropertyValue(propertyName, value));
	}
	
	private function isNestedProperty(propertyName:String):Boolean {
		return (propertyName.indexOf(NESTED_PROPERTY_SEPARATOR) > -1);
	}
	
	private function getFinalPropertyName(propertyPath:String):String {
		var start:Number = propertyPath.lastIndexOf(NESTED_PROPERTY_SEPARATOR) + 1;
		/*if (start < 1) {
			start = propertyPath.indexOf(PROPERTY_PREFIX_SEPARATOR) + 1;
		}*/
		if (propertyPath.indexOf(PROPERTY_KEY_PREFIX) < 0 && propertyPath.charAt(propertyPath.length-1) != PROPERTY_KEY_SUFFIX) {
			return propertyPath.substring(start);
		}
		return propertyPath.substring(start, propertyPath.indexOf(PROPERTY_KEY_PREFIX));
	}
	
	/*private function getPropertyPrefix(propertyPath:String):String {
		var length:Number = propertyPath.indexOf(PROPERTY_PREFIX_SEPARATOR);
		if (length > -1) {
			return propertyPath.substr(0, length);
		}
		return null;
	}*/
	
	private function getKeyName(propertyPath:String):String {
		if (propertyPath.indexOf(PROPERTY_KEY_PREFIX) < 0 && propertyPath.charAt(propertyPath.length-1) != PROPERTY_KEY_SUFFIX) {
			return null;
		}
		var key:String = propertyPath.substring(propertyPath.indexOf(PROPERTY_KEY_PREFIX)+1, propertyPath.length-1);
		if (key.indexOf("\"") > -1) {
			return key.substring(key.indexOf("\"")+1, key.lastIndexOf("\""));
		}
		if (key.indexOf("'") > -1) {
			return key.substring(key.indexOf("'")+1, key.lastIndexOf("'"));
		}
		return key;
	}
	
	private function transformPropertyName(propertyName:String):String {
		if (!propertyName) {
			throw new IllegalArgumentException("Name of property must not be null, undefined or a blank string.", this, arguments);
		}
		if (propertyName.indexOf(PROPERTY_PREFIX) == 0) {
			return propertyName.substring(PROPERTY_PREFIX.length);
		}
		if (propertyName.indexOf(METHOD_PREFIX) == 0) {
			return propertyName.substring(METHOD_PREFIX.length);
		}
		return StringUtil.ucFirst(propertyName);
	}
	
	private function transformPropertyValue(propertyValue:PropertyValue) {
		if ((typeof(propertyValue.getValue()) == "string" || propertyValue instanceof String) && propertyValue.getType()) {
			// check prefixes, boolean, number, ...
			var propertyValueConverter:PropertyValueConverter = findPropertyValueConverter(propertyValue.getType(), propertyValue.getName());
			if (propertyValueConverter) {
				return propertyValueConverter.convertPropertyValue(propertyValue.getValue(), propertyValue.getType());
			} else {
				return propertyValue.getValue();
			}
		}
		return propertyValue.getValue();
	}

	public function setPropertyValuesByPropertyValueSet(propertyValues:PropertyValueSet):Void {
		var values:Array = propertyValues.getPropertyValues();
		for (var i:Number = 0; i < values.length; i++) {
			setPropertyValueByPropertyValue(values[i]);
		}
	}
	
	public function setPropertyValuesByMap(propertyValues:Map):Void {
		setPropertyValuesByPropertyValueSet(new MutablePropertyValueSet(propertyValues));
	}
	
	public function findPropertyValueConverter(requiredType:Function, propertyPath:String):PropertyValueConverter {
		if (propertyValueConverters.isEmpty()) {
			return null;
		}
		if (propertyPath) {
			var holder:PropertyValueConverterHolder = propertyValueConverters.get(propertyPath);
			var converter:PropertyValueConverter = holder.getPropertyValueConverter(requiredType);
			if (converter) {
				return converter;
			}
		}
		return getPropertyValueConverterByType(requiredType);
	}
	
	private function getPropertyValueConverterByType(requiredType:Function):PropertyValueConverter {
		if (requiredType) {
			var converter:PropertyValueConverter = propertyValueConverters.get(requiredType);
			if (!converter) {
				converter = null;
				var keys:Array = propertyValueConverters.getKeys();
				for (var i:Number = 0; i < keys.length; i++) {
					var key = keys[i];
					if (key instanceof Function && (ClassUtil.isSubClassOf(requiredType, key) || ClassUtil.isImplementationOf(requiredType, key))) {
						converter = propertyValueConverters.get(key);
					}
				}
			}
			return converter;
		}
		return null;
	}

	public function registerPropertyValueConverterByTypeAndConverter(requiredType:Function, propertyValueConverter:PropertyValueConverter):Void {
		registerPropertyValueConverterByTypeAndPathAndConverter(requiredType, null, propertyValueConverter);
	}
	
	public function registerPropertyValueConverterByTypeAndPathAndConverter(requiredType:Function, propertyPath:String, propertyValueConverter:PropertyValueConverter):Void {
		if (!requiredType && !propertyPath) {
			throw new IllegalArgumentException("Either requiredType or propertyPath is required.", this, arguments);
		}
		if (propertyPath) {
			propertyValueConverters.put(propertyPath, new PropertyValueConverterHolder(propertyValueConverter, requiredType));
		} else {
			propertyValueConverters.put(requiredType, propertyValueConverter);
		}
	}
	
	public function getWrappedObject(Void) {
		return wrappedObject;
	}
	
	public function setWrappedObject(wrappedObject):Void {
		//if (!wrappedObject) throw new IllegalArgumentException("Wrapped object must not be null or undefined.", this, arguments);
		this.wrappedObject = wrappedObject;
	}
	
}