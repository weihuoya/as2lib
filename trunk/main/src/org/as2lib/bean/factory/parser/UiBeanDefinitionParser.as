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
import org.as2lib.bean.factory.BeanDefinitionStoreException;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanDefinitionHolder;
import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.config.MethodInvokingFactoryBean;
import org.as2lib.bean.factory.config.PropertyPathFactoryBean;
import org.as2lib.bean.factory.config.RuntimeBeanReference;
import org.as2lib.bean.factory.config.VariableRetrievingFactoryBean;
import org.as2lib.bean.factory.parser.XmlBeanDefinitionParser;
import org.as2lib.bean.factory.support.BeanDefinitionRegistry;
import org.as2lib.bean.PropertyValues;
import org.as2lib.context.support.LoadingApplicationContextFactoryBean;
import org.as2lib.env.reflect.DelegateFactoryBean;
import org.as2lib.util.StringUtil;
import org.as2lib.util.TextUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.parser.UiBeanDefinitionParser extends XmlBeanDefinitionParser {
	
	public static var DATA_BINDING_PREFIX:String = "{";
	public static var DATA_BINDING_SUFFIX:String = "}";
	
	public static var POPULATE_PREFIX:String = "_";
	public static var INSTANTIATE_WITH_PROPERTY_SUFFIX:String = "_";
	public static var ENFORCE_ACCESS_PREFIX:String = "_";
	
	public static var PROPERTY_PATH:String = "p";
	public static var VARIABLE_RETRIEVAL:String = "v";
	public static var METHOD_INVOCATION:String = "m";
	public static var DELEGATE:String = "d";
	public static var RUNTIME_BEAN_REFERENCE:String = "r";
	
	public static var PROPERTY_KEY_SEPARATOR:String = "-";
	
	public static var PROPERTY_PATH_FACTORY_BEAN_CLASS_NAME:String = "org.as2lib.bean.factory.config.PropertyPathFactoryBean";
	public static var VARIABLE_RETRIEVING_FACTORY_BEAN_CLASS_NAME:String = "org.as2lib.bean.factory.config.VariableRetrievingFactoryBean";
	public static var METHOD_INVOKING_FACTORY_BEAN_CLASS_NAME:String = "org.as2lib.bean.factory.config.MethodInvokingFactoryBean";
	public static var DELEGATE_FACTORY_BEAN_CLASS_NAME:String = "org.as2lib.env.reflect.DelegateFactoryBean";
	public static var LOADING_APPLICATION_CONTEXT_FACTORY_BEAN_CLASS = "org.as2lib.context.support.LoadingApplicationContextFactoryBean";
	
	/**
	 * Constructs a new {@code UiBeanDefinitionParser} instance with a default bean
	 * definition registry.
	 * 
	 * @param registry the default registry to register bean definitions to
	 */
	public function UiBeanDefinitionParser(registry:BeanDefinitionRegistry) {
		super(registry);
		// forces classes to be included in the swf 
		var p:Function = PropertyPathFactoryBean;
		var v:Function = VariableRetrievingFactoryBean;
		var m:Function = MethodInvokingFactoryBean;
		var d:Function = DelegateFactoryBean;
		var l:Function = LoadingApplicationContextFactoryBean;
	}
	
	private function parseUnknownElement(element:XMLNode):Void {
		convertBeanElement(element);
		var holder:BeanDefinitionHolder = parseBeanDefinitionElement(element);
		registerBeanDefinition(holder);
	}
	
	private function convertBeanElement(element:XMLNode):Void {
		// Mtasc ships with Flash 7 sources for xml.
		var namespace:String = element["namespaceURI"];
		var name:String;
		if (namespace == "" || namespace == null) {
			name = element.nodeName;
		}
		else {
			name = element["localName"];
		}
		if (name.charAt(0) == POPULATE_PREFIX) {
			name = name.substring(1);
			element.attributes[POPULATE_ATTRIBUTE] = getPopulateValue();
		}
		if (name.charAt(name.length - 1) == INSTANTIATE_WITH_PROPERTY_SUFFIX) {
			name = name.substring(0, name.length - 1);
			element.attributes[INSTANTIATE_WITH_PROPERTY_ATTRIBUTE] = TRUE_VALUE;
		}
		if (name != BEAN_ELEMENT) {
			if (namespace == "" || namespace == null) {
				element.attributes[PARENT_ATTRIBUTE] = name;
			}
			else {
				if (namespace.indexOf("*") != -1) {
					var applicationContextClass:String = element.attributes[CLASS_ATTRIBUTE];
					var contextClassElement:XMLNode = createPropertyElement("applicationContextClass", applicationContextClass);
					contextClassElement.attributes[TYPE_ATTRIBUTE] = CLASS_TYPE_VALUE;
					element.appendChild(contextClassElement);
					element.attributes[CLASS_ATTRIBUTE] = LOADING_APPLICATION_CONTEXT_FACTORY_BEAN_CLASS;
					element.attributes[POPULATE_ATTRIBUTE] = POPULATE_BEFORE_VALUE;
					var beanDefinitionUri:String = StringUtil.replace(namespace, "*", name);
					element.appendChild(createPropertyElement("beanDefinitionUri", beanDefinitionUri));
					var targetBeanName:String = TextUtil.lcFirst(name);
					element.appendChild(createPropertyElement("targetBeanName", targetBeanName));
				}
				else {
					if (element.attributes[CLASS_ATTRIBUTE] == null) {
						element.attributes[CLASS_ATTRIBUTE] = namespace + "." + name;
					}
				}
			}
		}
	}
	
	private function getPopulateValue(Void):String {
		return POPULATE_AFTER_VALUE;
	}
	
	private function parseBeanDefinitionElementWithoutRegardToNameOrAliases(element:XMLNode, beanName:String):BeanDefinition {
		for (var i:String in element.attributes) {
			if (i != CLASS_ATTRIBUTE && i != PARENT_ATTRIBUTE
					&& i != ID_ATTRIBUTE && i != NAME_ATTRIBUTE
					&& i != DEPENDS_ON_ATTRIBUTE && i != DEPENDS_ON_ATTRIBUTE
					&& i != FACTORY_METHOD_ATTRIBUTE && i != FACTORY_BEAN_ATTRIBUTE
					&& i != DEPENDENCY_CHECK_ATTRIBUTE && i != AUTOWIRE_ATTRIBUTE
					&& i != INIT_METHOD_ATTRIBUTE && i != DESTROY_METHOD_ATTRIBUTE
					&& i != ABSTRACT_ATTRIBUTE && i != SINGLETON_ATTRIBUTE
					&& i != LAZY_INIT_ATTRIBUTE && i != DEFAULT_PROPERTY_ATTRIBUTE
					&& i != STYLE_ATTRIBUTE && i != POPULATE_ATTRIBUTE) {
				convertAttributeToPropertyElement(i, element);
			}
		}
		return super.parseBeanDefinitionElementWithoutRegardToNameOrAliases(element, beanName);
	}
	
	private function convertAttributeToPropertyElement(attribute:String, element:XMLNode):Void {
		element.appendChild(createPropertyElement(attribute, element.attributes[attribute]));
		delete element.attributes[attribute];
	}
	
	private function parseConstructorArgElements(beanElement:XMLNode, beanName:String):ConstructorArgumentValues {
		var node:XMLNode = beanElement.firstChild;
		if (node.nodeType == 3) {
			if (node.nodeValue != "") {
				var constructorArgsElement:XMLNode = new XMLNode(1, CONSTRUCTOR_ARGS_ELEMENT);
				beanElement.insertBefore(constructorArgsElement, node);
				node.removeNode();
				constructorArgsElement.appendChild(node);
			}
		}
		return super.parseConstructorArgElements(beanElement, beanName);
	}
	
	private function parsePropertyElements(beanElement:XMLNode, beanName:String):PropertyValues {
		var counter:Number = 0;
		var nodes:Array = beanElement.childNodes;
		for (var i:Number = 0; i < nodes.length; i++) {
			var node:XMLNode = nodes[i];
			var propertyElement:XMLNode = node;
			if (node.nodeName != PROPERTY_ELEMENT && node.nodeName != CONSTRUCTOR_ARG_ELEMENT
					&& node.nodeName != LOOKUP_METHOD_ELEMENT && node.nodeName != REPLACED_METHOD_ELEMENT
					&& node.nodeName != CONSTRUCTOR_ARGS_ELEMENT) {
				propertyElement = new XMLNode(1, PROPERTY_ELEMENT);
				beanElement.insertBefore(propertyElement, node);
				node.removeNode();
				if (isUpperCaseLetter(node["localName"].charAt(0)) || node.nodeName == BEAN_ELEMENT) {
					propertyElement.appendChild(node);
				}
				else {
					propertyElement.attributes[NAME_ATTRIBUTE] = node.nodeName;
					propertyElement.appendChild(node.firstChild);
				}
				if (node.attributes[TYPE_ATTRIBUTE] != null) {
					propertyElement.attributes[TYPE_ATTRIBUTE] = node.attributes[TYPE_ATTRIBUTE];
				}
				if (node.attributes[INDEX_ATTRIBUTE] != null) {
					propertyElement.attributes[INDEX_ATTRIBUTE] = node.attributes[INDEX_ATTRIBUTE];
				}
			}
			propertyElement.attributes[NAME_ATTRIBUTE] = parsePropertyName(propertyElement);
		}
		return super.parsePropertyElements(beanElement, beanName);
	}
	
	private function parsePropertyName(propertyElement:XMLNode):String {
		var result:String = propertyElement.attributes[NAME_ATTRIBUTE];
		if (result.charAt(0) == ENFORCE_ACCESS_PREFIX) {
			if (propertyElement.attributes[ENFORCE_ACCESS_ATTRIBUTE] == null) {
				propertyElement.attributes[ENFORCE_ACCESS_ATTRIBUTE] = TRUE_VALUE;
			}
			result = result.substring(1);
		}
		if (result.indexOf(PROPERTY_KEY_SEPARATOR) != -1) {
			var tokens:Array = result.split(PROPERTY_KEY_SEPARATOR);
			result = tokens[0];
			for (var j:Number = 1; j < tokens.length; j++) {
				result += AbstractBeanWrapper.PROPERTY_KEY_PREFIX;
				result += tokens[j];
				result += AbstractBeanWrapper.PROPERTY_KEY_SUFFIX;
			}
		}
		return result;
	}
	
	private function parsePropertySubElement(element:XMLNode, beanName:String) {
		var propertyValue = super.parsePropertySubElement(element, beanName);
		if (element.attributes[ID_ATTRIBUTE] != null || element.attributes[NAME_ATTRIBUTE] != null ||
				element.attributes[CLASS_ATTRIBUTE] == LOADING_APPLICATION_CONTEXT_FACTORY_BEAN_CLASS) {
			if (propertyValue instanceof BeanDefinitionHolder) {
				var holder:BeanDefinitionHolder = propertyValue;
				registerBeanDefinition(holder);
				return new RuntimeBeanReference(holder.getBeanName());
			}
		}
		return propertyValue;
	}
	
	private function parseUnknownPropertySubElement(element:XMLNode, beanName:String) {
		convertBeanElement(element);
		return parseBeanDefinitionElement(element);
	}
	
	private function parseLiteralValue(value:String, beanName:String) {
		if (isDataBinding(value)) {
			return parseDataBindingValue(value, beanName);
		}
		return super.parseLiteralValue(value, beanName);
	}
	
	private function isDataBinding(value:String):Boolean {
		return ((value.charAt(0) == DATA_BINDING_PREFIX || value.charAt(1) == DATA_BINDING_PREFIX)
				&& value.charAt(value.length - 1) == DATA_BINDING_SUFFIX);
	}
	
	private function parseDataBindingValue(value:String, beanName:String) {
		var tokens:Array = getValueTokens(value, beanName);
		if (value.indexOf(PROPERTY_PATH + DATA_BINDING_PREFIX) == 0
				|| value.charAt(0) == DATA_BINDING_PREFIX) {
			return parsePropertyPathValue(tokens[1], tokens[2], tokens[0], beanName);
		}
		if (value.indexOf(VARIABLE_RETRIEVAL + DATA_BINDING_PREFIX) == 0) {
			return parseVariableRetrievalValue(tokens[1], tokens[2], tokens[0], beanName);
		}
		if (value.indexOf(DELEGATE + DATA_BINDING_PREFIX) == 0) {
			return parseDelegateValue(tokens[1], tokens[2], tokens[0], beanName);
		}
		if (value.indexOf(METHOD_INVOCATION + DATA_BINDING_PREFIX) == 0) {
			return parseMethodInvocationValue(tokens[1], tokens[2], tokens[0], beanName);
		}
		if (value.indexOf(RUNTIME_BEAN_REFERENCE + DATA_BINDING_PREFIX) == 0) {
			return parseRuntimeBeanReferenceValue(tokens[3], beanName);
		}
		throw new BeanDefinitionStoreException(beanName, "Unknown data binding value '" + value + "'.", this, arguments);
	}
	
	private function getValueTokens(value:String, beanName:String):Array {
		var result:Array = new Array();
		var prefixIndex:Number = value.indexOf(DATA_BINDING_PREFIX);
		var strippedValue:String = value.substring(prefixIndex + 1, value.length - 1);
		var isStatic:Boolean = false;
		var targetObject:String;
		var targetMember:String;
		var dotIndex:Number;
		var endIndex:Number = strippedValue.indexOf("[");
		if (endIndex == -1) {
			dotIndex = strippedValue.lastIndexOf(".");
		}
		else {
			dotIndex = strippedValue.lastIndexOf(".", endIndex);
		}
		if (dotIndex == -1) {
			targetObject = beanName;
			targetMember = strippedValue;
		}
		else {
			targetObject = strippedValue.substring(0, dotIndex);
			targetMember = strippedValue.substring(dotIndex + 1);
			var lc:String = targetObject.charAt(targetObject.lastIndexOf(".") + 1);
			if (isUpperCaseLetter(lc)) {
				isStatic = true;
			}
			else {
				// TODO Don't know whether targetObject must always be just the first bean if not static.
				dotIndex = targetObject.indexOf(".");
				if (dotIndex != -1) {
					targetMember = targetObject.substring(dotIndex + 1) + "." + targetMember;
					targetObject = targetObject.substring(0, dotIndex);
				}
			}
		}
		result.push(isStatic);
		result.push(targetObject);
		result.push(targetMember);
		result.push(strippedValue);
		return result;
	}
	
	private function isUpperCaseLetter(letter:String):Boolean {
		if (letter == null) {
			return false;
		}
		return (letter.toUpperCase() == letter);
	}
	
	private function parsePropertyPathValue(targetObject:String, targetMember:String, isStatic:Boolean, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		if (isStatic) {
			throw new BeanDefinitionStoreException(beanName, "Property path data binding cannot be used for static properties.", this, arguments);
		}
		result.attributes[CLASS_ATTRIBUTE] = PROPERTY_PATH_FACTORY_BEAN_CLASS_NAME;
		result.attributes[POPULATE_ATTRIBUTE] = POPULATE_BEFORE_VALUE;
		result.appendChild(createPropertyElement("targetBeanName", targetObject));
		result.appendChild(createPropertyElement("propertyPath", targetMember));
		return parseBeanDefinitionElement(result);
	}
	
	private function parseVariableRetrievalValue(targetObject:String, targetMember:String, isStatic:Boolean, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		result.attributes[CLASS_ATTRIBUTE] = VARIABLE_RETRIEVING_FACTORY_BEAN_CLASS_NAME;
		result.attributes[POPULATE_ATTRIBUTE] = POPULATE_BEFORE_VALUE;
		if (isStatic) {
			result.appendChild(createPropertyElement("staticVariable", targetObject + "." + targetMember));
		}
		else {
			// TODO targetBean must not be the name of the target bean, but the target bean itself
			result.appendChild(createBeanReferencePropertyElement("targetBean", targetObject));
			result.appendChild(createPropertyElement("targetVariable", targetMember));
		}
		return parseBeanDefinitionElement(result);
	}
	
	private function parseDelegateValue(targetObject:String, targetMember:String, isStatic:Boolean, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		if (isStatic) {
			throw new BeanDefinitionStoreException(beanName, "Delegate data binding cannot be used for static methods.", this, arguments);
		}
		result.attributes[CLASS_ATTRIBUTE] = DELEGATE_FACTORY_BEAN_CLASS_NAME;
		result.attributes[POPULATE_ATTRIBUTE] = POPULATE_BEFORE_VALUE;
		result.appendChild(createPropertyElement("targetBeanName", targetObject));
		result.appendChild(createPropertyElement("methodName", targetMember));
		return parseBeanDefinitionElement(result);
	}
	
	private function parseMethodInvocationValue(targetObject:String, targetMember:String, isStatic:Boolean, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		result.attributes[CLASS_ATTRIBUTE] = METHOD_INVOKING_FACTORY_BEAN_CLASS_NAME;
		result.attributes[POPULATE_ATTRIBUTE] = POPULATE_BEFORE_VALUE;
		if (isStatic) {
			result.appendChild(createPropertyElement("staticMethod", targetObject + "." + targetMember));
		}
		else {
			// TODO targetBean must not be the name of the target bean, but the target bean itself
			result.appendChild(createBeanReferencePropertyElement("targetBean", targetObject));
			result.appendChild(createPropertyElement("targetVariable", targetMember));
		}
		return parseBeanDefinitionElement(result);
	}
	
	private function parseRuntimeBeanReferenceValue(referenceBeanName:String, beanName:String):RuntimeBeanReference {
		var beanReference:XMLNode = new XMLNode(1, REF_ELEMENT);
		beanReference.attributes[BEAN_REF_ATTRIBUTE] = referenceBeanName;
		return parseBeanReferenceElement(beanReference, beanName);
	}
	
	private function createPropertyElement(name:String, value:String):XMLNode {
		var result:XMLNode = new XMLNode(1, PROPERTY_ELEMENT);
		result.attributes[NAME_ATTRIBUTE] = name;
		if (value != null) {
			result.attributes[VALUE_ATTRIBUTE] = value;
		}
		return result;
	}
	
	private function createBeanReferencePropertyElement(name:String, referenceBeanName:String):XMLNode {
		var result:XMLNode = createPropertyElement(name);
		var beanReference:XMLNode = new XMLNode(1, REF_ELEMENT);
		beanReference.attributes[BEAN_REF_ATTRIBUTE] = referenceBeanName;
		result.appendChild(beanReference);
		return result;
	}
	
}