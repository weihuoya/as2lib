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
	
	public static var PROPERTY_PATH:String = "p";
	public static var VARIABLE_RETRIEVAL:String = "v";
	public static var METHOD_INVOCATION:String = "m";
	public static var DELEGATE:String = "d";
	public static var RUNTIME_BEAN_REFERENCE:String = "b";
	
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
	
	private function parseElement(element:XMLNode):Void {
		if (element.nodeName != ALIAS_ELEMENT && element.nodeName != BEAN_ELEMENT) {
			convertBeanElement(element);
		}
		super.parseElement(element);
	}
	
	private function convertBeanElement(element:XMLNode):Void {
		// Mtasc ships with Flash 7 sources for xml.
		var namespace:String = element["namespaceURI"];
		if (namespace == "" || namespace == null) {
			element.attributes[PARENT_ATTRIBUTE] = element.nodeName;
		}
		else {
			var localName:String = element["localName"];
			if (namespace.indexOf("*") != -1) {
				var applicationContextClass:String = element.attributes[CLASS_ATTRIBUTE];
				var contextClassElement:XMLNode = createPropertyElement("applicationContextClass", applicationContextClass);
				contextClassElement.attributes[TYPE_ATTRIBUTE] = CLASS_TYPE_VALUE;
				element.appendChild(contextClassElement);
				element.attributes[CLASS_ATTRIBUTE] = LOADING_APPLICATION_CONTEXT_FACTORY_BEAN_CLASS;
				var beanDefinitionUri:String = StringUtil.replace(namespace, "*", localName);
				element.appendChild(createPropertyElement("beanDefinitionUri", beanDefinitionUri));
				var targetBeanName:String = TextUtil.lcFirst(localName);
				element.appendChild(createPropertyElement("targetBeanName", targetBeanName));
			}
			else {
				if (element.attributes[CLASS_ATTRIBUTE] == null) {
					element.attributes[CLASS_ATTRIBUTE] = namespace + "." + localName;
				}
			}
		}
		element.nodeName = BEAN_ELEMENT;
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
					&& i != LAZY_INIT_ATTRIBUTE && i != DEFAULT_PROPERTY_ATTRIBUTE) {
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
			var propertyName:String = propertyElement.attributes[NAME_ATTRIBUTE];
			if (propertyName.indexOf(PROPERTY_KEY_SEPARATOR) != -1) {
				var tokens:Array = propertyName.split(PROPERTY_KEY_SEPARATOR);
				propertyName = tokens[0];
				for (var j:Number = 1; j < tokens.length; j++) {
					propertyName += AbstractBeanWrapper.PROPERTY_KEY_PREFIX;
					propertyName += tokens[j];
					propertyName += AbstractBeanWrapper.PROPERTY_KEY_SUFFIX;
				}
				propertyElement.attributes[NAME_ATTRIBUTE] = propertyName;
			}
		}
		return super.parsePropertyElements(beanElement, beanName);
	}
	
	private function parsePropertyValue(element:XMLNode, beanName:String, propertyName:String) {
		var propertyValue = super.parsePropertyValue(element, beanName, propertyName);
		var value:String = element.attributes[VALUE_ATTRIBUTE];
		if (value != null && value == propertyValue) {
			if (isDataBinding(value)) {
				return parseDataBindingValue(value, beanName);
			}
		}
		return propertyValue;
	}
	
	private function parsePropertySubElement(element:XMLNode, beanName:String) {
		if (element.nodeType == 3 || element.nodeName == VALUE_ELEMENT) {
			var value:String;
			if (element.nodeType == 3) {
				value = element.nodeValue;
			}
			else {
				value = element.firstChild.nodeValue;
			}
			if (isDataBinding(value)) {
				return parseDataBindingValue(value, beanName);
			}
		}
		else if (element.nodeName != BEAN_ELEMENT && element.nodeName != REF_ELEMENT
				&& element.nodeName != IDREF_ELEMENT && element.nodeName != NULL_ELEMENT
				&& element.nodeName != ARRAY_ELEMENT && element.nodeName != LIST_ELEMENT
				&& element.nodeName != MAP_ELEMENT && element.nodeName != PROPS_ELEMENT) {
			convertBeanElement(element);
		}
		var propertyValue = super.parsePropertySubElement(element, beanName);
		// TODO: Refactor!
		if (element.attributes[ID_ATTRIBUTE] != null || element.attributes[NAME_ATTRIBUTE] != null) {
			if (propertyValue instanceof BeanDefinitionHolder) {
				var holder:BeanDefinitionHolder = propertyValue;
				registry.registerBeanDefinition(holder.getBeanName(), holder.getBeanDefinition());
				var aliases:Array = holder.getAliases();
				for (var i:Number = 0; i < aliases.length; i++) {
					registry.registerAlias(holder.getBeanName(), aliases[i]);
				}
				return new RuntimeBeanReference(holder.getBeanName());
			}
		}
		return propertyValue;
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
		else if (value.indexOf(VARIABLE_RETRIEVAL + DATA_BINDING_PREFIX) == 0) {
			return parseVariableRetrievalValue(tokens[1], tokens[2], tokens[0], beanName);
		}
		else if (value.indexOf(DELEGATE + DATA_BINDING_PREFIX) == 0) {
			return parseDelegateValue(tokens[1], tokens[2], tokens[0], beanName);
		}
		else if (value.indexOf(METHOD_INVOCATION + DATA_BINDING_PREFIX) == 0) {
			return parseMethodInvocationValue(tokens[1], tokens[2], tokens[0], beanName);
		}
		else if (value.indexOf(RUNTIME_BEAN_REFERENCE + DATA_BINDING_PREFIX) == 0) {
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
		}
		result.push(isStatic);
		result.push(targetObject);
		result.push(targetMember);
		result.push(strippedValue);
		return result;
	}
	
	private function parsePropertyPathValue(targetObject:String, targetMember:String, isStatic:Boolean, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		if (isStatic) {
			throw new BeanDefinitionStoreException(beanName, "Property path data binding cannot be used for static properties.", this, arguments);
		}
		result.attributes[CLASS_ATTRIBUTE] = PROPERTY_PATH_FACTORY_BEAN_CLASS_NAME;
		result.appendChild(createPropertyElement("targetBeanName", targetObject));
		result.appendChild(createPropertyElement("propertyPath", targetMember));
		return parseBeanDefinitionElement(result);
	}
	
	private function parseVariableRetrievalValue(targetObject:String, targetMember:String, isStatic:Boolean, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		result.attributes[CLASS_ATTRIBUTE] = VARIABLE_RETRIEVING_FACTORY_BEAN_CLASS_NAME;
		if (isStatic) {
			result.appendChild(createPropertyElement("staticVariable", targetObject + "." + targetMember));
		}
		else {
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
		result.appendChild(createPropertyElement("targetBeanName", targetObject));
		result.appendChild(createPropertyElement("methodName", targetMember));
		return parseBeanDefinitionElement(result);
	}
	
	private function parseMethodInvocationValue(targetObject:String, targetMember:String, isStatic:Boolean, beanName:String):BeanDefinitionHolder {
		var result:XMLNode = new XMLNode(1, BEAN_ELEMENT);
		result.attributes[CLASS_ATTRIBUTE] = METHOD_INVOKING_FACTORY_BEAN_CLASS_NAME;
		if (isStatic) {
			result.appendChild(createPropertyElement("staticMethod", targetObject + "." + targetMember));
		}
		else {
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
	
	private function isUpperCaseLetter(letter:String):Boolean {
		return (letter.toUpperCase() == letter);
	}
	
}