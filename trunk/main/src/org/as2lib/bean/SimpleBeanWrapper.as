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

import org.as2lib.bean.AbstractBeanWrapper;
import org.as2lib.bean.BeanWrapper;
import org.as2lib.bean.converter.BooleanConverter;
import org.as2lib.bean.converter.ClassConverter;
import org.as2lib.bean.converter.NumberConverter;
import org.as2lib.bean.converter.StringArrayConverter;
import org.as2lib.bean.MethodInvocationException;
import org.as2lib.bean.NotReadablePropertyException;
import org.as2lib.bean.NotWritablePropertyException;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValueConverter;
import org.as2lib.bean.PropertyValueConverterHolder;
import org.as2lib.bean.PropertyValues;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.ClassUtil;
import org.as2lib.util.StringUtil;
import org.as2lib.util.TextUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.SimpleBeanWrapper extends AbstractBeanWrapper implements BeanWrapper {
	
	private var wrappedBean;
	private var propertyValueConverters:Map;
	
	public function SimpleBeanWrapper(wrappedBean) {
		setWrappedBean(wrappedBean);
		propertyValueConverters = new HashMap();
		registerPropertyValueConverter(Number, null, new NumberConverter());
		registerPropertyValueConverter(Boolean, null, new BooleanConverter());
		registerPropertyValueConverter(Function, null, new ClassConverter());
		registerPropertyValueConverter(Array, null, new StringArrayConverter());
	}
	
	public function hasWritableProperty(propertyName:String):Boolean {
		var transformedPropertyName:String = transformPropertyName(propertyName);
		if (isVariableName(propertyName)) {
			// detection of whether variable is declared is not possible
			return true;
		}
		if (isMethodName(propertyName)) {
			return (wrappedBean[transformedPropertyName] != null);
		}
		return (wrappedBean["set" + transformedPropertyName] != null);
	}
	
	public function getPropertyValue(propertyName:String) {
		if (isNestedProperty(propertyName)) {
			var oldWrappedBean = wrappedBean;
			var nodes:Array = propertyName.split(NESTED_PROPERTY_SEPARATOR);
			for (var i:Number = 0; i < nodes.length - 1; i++) {
				wrappedBean = getPropertyValue(nodes[i]);
			}
			var value = getPropertyValue(nodes[nodes.length - 1]);
			wrappedBean = oldWrappedBean;
			return value;
		}
		var transformedPropertyName:String = transformPropertyName(propertyName);
		var key:String = getKey(propertyName);
		if (isVariableName(propertyName)) {
			return getPropertyValueByVariableAccess(transformedPropertyName, key);
		}
		if (isMethodName(propertyName)) {
			return getPropertyValueByMethodInvocation(transformedPropertyName, key);
		}
		return getPropertyValueByMethodInvocation("get" + transformedPropertyName, key);
	}
	
	private function getPropertyValueByVariableAccess(variableName:String, key:String) {
		try {
			if (key != null) {
				return wrappedBean[variableName][key];
			}
			return wrappedBean[variableName];
		} catch (exception) {
			throw (new MethodInvocationException("Variable get-access to variable '" + variableName + "' failed.", this, arguments)).initCause(exception);
		}
	}
	
	private function getPropertyValueByMethodInvocation(methodName:String, key:String) {
		if (wrappedBean[methodName] == null) {
			throw new NotReadablePropertyException("Method with name '" + methodName + "' does not exist on wrapped bean [" + wrappedBean + "].", this, arguments);
		}
		try {
			if (key != null) {
				if (isNaN(key)) {
					return wrappedBean[methodName](key);
				} else {
					return wrappedBean[methodName](Number(key));
				}
			}
			return wrappedBean[methodName]();
		} catch (exception) {
			throw (new MethodInvocationException("Method invocation of method '" + methodName + "' on wrapped bean [" + wrappedBean + "] failed.", this, arguments)).initCause(exception);
		}
	}
	
	public function setPropertyValue(propertyValue:PropertyValue):Void {
		var propertyName:String = propertyValue.getName();
		if (isNestedProperty(propertyName)) {
			var oldWrappedBean = wrappedBean;
			var nodes:Array = propertyName.split(NESTED_PROPERTY_SEPARATOR);
			for (var i:Number = 0; i < nodes.length - 1; i++) {
				wrappedBean = getPropertyValue(nodes[i]);
			}
			setPropertyValue(new PropertyValue(nodes[nodes.length - 1], propertyValue.getValue(), propertyValue.getType()));
			wrappedBean = oldWrappedBean;
			return;
		}
		var transformedPropertyName:String = transformPropertyName(propertyName);
		var key:String = getKey(propertyName);
		var value = convertPropertyValue(propertyValue);
		if (isVariableName(propertyName)) {
			setPropertyValueByVariableAccess(transformedPropertyName, key, value);
			return;
		}
		if (isMethodName(propertyName)) {
			setPropertyValueByMethodInvocation(transformedPropertyName, key, value);
			return;
		}
		try {
			setPropertyValueByMethodInvocation("set" + transformedPropertyName, key, value);
		}
		catch (exception:org.as2lib.bean.NotWritablePropertyException) {
			try {
				setPropertyValueByMethodInvocation("add" + transformedPropertyName, key, value);
			}
			catch (ex:org.as2lib.bean.NotWritablePropertyException) {
				setPropertyValueByMethodInvocation("put" + transformedPropertyName, key, value);
			}
		}
	}
	
	private function setPropertyValueByVariableAccess(variableName, key, propertyValue):Void {
		try {
			if (key != null) {
				wrappedBean[variableName][key] = propertyValue;
			} else {
				wrappedBean[variableName] = propertyValue;
			}
		} catch (exception) {
			throw (new MethodInvocationException("Variable set-access to variable '" + variableName + "' failed.", this, arguments)).initCause(exception);
		}
	}
	
	private function setPropertyValueByMethodInvocation(methodName, key, value):Void {
		if (wrappedBean[methodName] == null) {
			throw new NotWritablePropertyException("Method with name '" + methodName + "' does not exist on wrapped bean [" + wrappedBean + "].", this, arguments);
		}
		try {
			if (key != null) {
				if (isNaN(key)) {
					wrappedBean[methodName](key, value);
				} else {
					wrappedBean[methodName](Number(key), value);
				}
			} else {
				wrappedBean[methodName](value);
			}
		} catch (exception) {
			throw (new MethodInvocationException("Method invocation of method '" + methodName + "' on wrapped bean [" + wrappedBean + "] failed.", this, arguments)).initCause(exception);
		}
	}
	
	private function isNestedProperty(propertyName:String):Boolean {
		return (propertyName.indexOf(NESTED_PROPERTY_SEPARATOR) > -1);
	}
	
	private function isVariableName(name:String):Boolean {
		return (name.indexOf(VARIABLE_PREFIX) == 0);
	}
	
	private function isMethodName(name:String):Boolean {
		return (name.indexOf(METHOD_PREFIX) == 0);
	}
	
	private function getKey(propertyName:String):String {
		if (propertyName.indexOf(PROPERTY_KEY_PREFIX) < 0 && propertyName.charAt(propertyName.length-1) != PROPERTY_KEY_SUFFIX) {
			return null;
		}
		var key:String = propertyName.substring(propertyName.indexOf(PROPERTY_KEY_PREFIX) + 1, propertyName.length - 1);
		if (key.indexOf("\"") > -1) {
			return key.substring(key.indexOf("\"") + 1, key.lastIndexOf("\""));
		}
		if (key.indexOf("'") > -1) {
			return key.substring(key.indexOf("'") + 1, key.lastIndexOf("'"));
		}
		return key;
	}
	
	private function transformPropertyName(propertyName:String):String {
		if (propertyName == null || propertyName == "") {
			throw new IllegalArgumentException("Name of property must not be 'null', 'undefined' or empty.", this, arguments);
		}
		if (StringUtil.startsWith(propertyName, VARIABLE_PREFIX)) {
			return propertyName.substring(VARIABLE_PREFIX.length);
		}
		if (StringUtil.startsWith(propertyName, METHOD_PREFIX)) {
			return propertyName.substring(METHOD_PREFIX.length);
		}
		if (propertyName.indexOf(PROPERTY_KEY_PREFIX) > -1) {
			propertyName = propertyName.substr(0, propertyName.indexOf(PROPERTY_KEY_PREFIX));
		}
		return TextUtil.ucFirst(propertyName);
	}
	
	private function convertPropertyValue(propertyValue:PropertyValue) {
		var value:String = propertyValue.getValue();
		if (typeof(value) == "string" || value instanceof String) {
			var type:Function = propertyValue.getType();
			var propertyValueConverter:PropertyValueConverter = findPropertyValueConverter(type, propertyValue.getName());
			if (propertyValueConverter != null) {
				return propertyValueConverter.convertPropertyValue(propertyValue.getValue(), type);
			}
		}
		return value;
	}
	
	public function setPropertyValues(propertyValues:PropertyValues):Void {
		var values:Array = propertyValues.getPropertyValues();
		for (var i:Number = 0; i < values.length; i++) {
			setPropertyValue(values[i]);
		}
	}
	
	public function findPropertyValueConverter(requiredType:Function, propertyName:String):PropertyValueConverter {
		if (propertyName != null) {
			var holder:PropertyValueConverterHolder = propertyValueConverters.get(propertyName);
			var converter:PropertyValueConverter = holder.getPropertyValueConverter(requiredType);
			if (converter != null) {
				return converter;
			}
		}
		if (requiredType != null) {
			var converter:PropertyValueConverter = propertyValueConverters.get(requiredType);
			if (converter == null) {
				var keys:Array = propertyValueConverters.getKeys();
				for (var i:Number = 0; i < keys.length; i++) {
					var key = keys[i];
					if (typeof(key) == "function") {
						if (ClassUtil.isSubClassOf(requiredType, key) || ClassUtil.isImplementationOf(requiredType, key)) {
							converter = propertyValueConverters.get(key);
							break;
						}
					}
				}
			}
			return converter;
		}
		return null;
	}
	
	public function registerPropertyValueConverter():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Function, PropertyValueConverter], registerPropertyValueConverterForType);
		o.addHandler([Function, String, PropertyValueConverter], registerPropertyValueConverterForProperty);
		o.forward(arguments);
	}
	
	public function registerPropertyValueConverterForType(requiredType:Function, propertyValueConverter:PropertyValueConverter):Void {
		registerPropertyValueConverterForProperty(requiredType, null, propertyValueConverter);
	}
	
	public function registerPropertyValueConverterForProperty(requiredType:Function, propertyName:String, propertyValueConverter:PropertyValueConverter):Void {
		if (requiredType == null && propertyName == null) {
			throw new IllegalArgumentException("Either argument 'requiredType' or 'propertyName' is required.", this, arguments);
		}
		if (propertyName != null) {
			propertyValueConverters.put(propertyName, new PropertyValueConverterHolder(propertyValueConverter, requiredType));
		} else {
			propertyValueConverters.put(requiredType, propertyValueConverter);
		}
	}
	
	public function getWrappedBean(Void) {
		return wrappedBean;
	}
	
	public function setWrappedBean(wrappedBean):Void {
		this.wrappedBean = wrappedBean;
	}
	
}