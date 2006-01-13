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

import org.as2lib.bean.factory.BeanDefinitionStoreException;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanDefinitionHolder;
import org.as2lib.bean.factory.config.ConstructorArgumentValue;
import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.config.RuntimeBeanReference;
import org.as2lib.bean.factory.parser.BeanDefinitionParser;
import org.as2lib.bean.factory.support.AbstractBeanDefinition;
import org.as2lib.bean.factory.support.BeanDefinitionRegistry;
import org.as2lib.bean.factory.support.ChildBeanDefinition;
import org.as2lib.bean.factory.support.LookupOverride;
import org.as2lib.bean.factory.support.ManagedList;
import org.as2lib.bean.factory.support.ManagedMap;
import org.as2lib.bean.factory.support.ManagedProperties;
import org.as2lib.bean.factory.support.MethodOverrides;
import org.as2lib.bean.factory.support.ReplaceOverride;
import org.as2lib.bean.factory.support.RootBeanDefinition;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.List;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.Properties;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.ClassNotFoundException;
import org.as2lib.util.StringUtil;
import org.as2lib.util.TrimUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.parser.XmlBeanDefinitionParser extends BasicClass implements BeanDefinitionParser {
	
	public static var BEAN_NAME_DELIMITERS:String = ",; ";
	
	/**
	 * Value of a T/F attribute that represents true.
	 * Anything else represents false. Case seNsItive.
	 */
	public static var TRUE_VALUE:String = "true";
	public static var DEFAULT_VALUE:String = "default";
	public static var DESCRIPTION_ELEMENT:String = "description";
	
	public static var AUTOWIRE_BY_NAME_VALUE:String = "byName";
	
	public static var DEPENDENCY_CHECK_ALL_ATTRIBUTE_VALUE:String = "all";
	public static var DEPENDENCY_CHECK_SIMPLE_ATTRIBUTE_VALUE:String = "simple";
	public static var DEPENDENCY_CHECK_OBJECTS_ATTRIBUTE_VALUE:String = "objects";
	
	public static var DEFAULT_LAZY_INIT_ATTRIBUTE:String = "default-lazy-init";
	public static var DEFAULT_AUTOWIRE_ATTRIBUTE:String = "default-autowire";
	public static var DEFAULT_DEPENDENCY_CHECK_ATTRIBUTE:String = "default-dependency-check";
	public static var DEFAULT_INIT_METHOD_ATTRIBUTE:String = "default-init-method";
	public static var DEFAULT_DESTROY_METHOD_ATTRIBUTE:String = "default-destroy-method";
	public static var DEFAULT_MERGE_ATTRIBUTE:String = "default-merge";
	
	public static var ALIAS_ELEMENT:String = "alias";
	public static var NAME_ATTRIBUTE:String = "name";
	public static var ALIAS_ATTRIBUTE:String = "alias";
	
	public static var BEAN_ELEMENT:String = "bean";
	public static var ID_ATTRIBUTE:String = "id";
	public static var PARENT_ATTRIBUTE:String = "parent";
	
	public static var CLASS_ATTRIBUTE:String = "class";
	public static var ABSTRACT_ATTRIBUTE:String = "abstract";
	public static var SINGLETON_ATTRIBUTE:String = "singleton";
	public static var LAZY_INIT_ATTRIBUTE:String = "lazy-init";
	public static var AUTOWIRE_ATTRIBUTE:String = "autowire";
	public static var DEPENDENCY_CHECK_ATTRIBUTE:String = "dependency-check";
	public static var DEPENDS_ON_ATTRIBUTE:String = "depends-on";
	public static var INIT_METHOD_ATTRIBUTE:String = "init-method";
	public static var DESTROY_METHOD_ATTRIBUTE:String = "destroy-method";
	public static var FACTORY_METHOD_ATTRIBUTE:String = "factory-method";
	public static var FACTORY_BEAN_ATTRIBUTE:String = "factory-bean";
	
	public static var CONSTRUCTOR_ARG_ELEMENT:String = "constructor-arg";
	public static var INDEX_ATTRIBUTE:String = "index";
	public static var TYPE_ATTRIBUTE:String = "type";
	public static var PROPERTY_ELEMENT:String = "property";
	public static var REF_ATTRIBUTE:String = "ref";
	public static var VALUE_ATTRIBUTE:String = "value";
	public static var LOOKUP_METHOD_ELEMENT:String = "lookup-method";
	
	public static var REPLACED_METHOD_ELEMENT:String = "replaced-method";
	public static var REPLACER_ATTRIBUTE:String = "replacer";
	
	public static var REF_ELEMENT:String = "ref";
	public static var IDREF_ELEMENT:String = "idref";
	public static var BEAN_REF_ATTRIBUTE:String = "bean";
	public static var LOCAL_REF_ATTRIBUTE:String = "local";
	public static var PARENT_REF_ATTRIBUTE:String = "parent";
	
	public static var VALUE_ELEMENT:String = "value";
	public static var NULL_ELEMENT:String = "null";
	public static var LIST_ELEMENT:String = "list";
	public static var MAP_ELEMENT:String = "map";
	public static var ENTRY_ELEMENT:String = "entry";
	public static var KEY_ELEMENT:String = "key";
	public static var KEY_ATTRIBUTE:String = "key";
	public static var KEY_REF_ATTRIBUTE:String = "key-ref";
	public static var VALUE_REF_ATTRIBUTE:String = "value-ref";
	public static var PROPS_ELEMENT:String = "props";
	public static var PROP_ELEMENT:String = "prop";
	public static var MERGE_ATTRIBUTE:String = "merge";
	
	/**
	 * Separator for generated bean names. If a class name or parent name is not
	 * unique, "#1", "#2" etc will be appended, until the name becomes unique.
	 */
	public static var GENERATED_BEAN_NAME_SEPARATOR:String = "#";
	
	private var registry:BeanDefinitionRegistry;
	
	private var defaultLazyInit:String;

	private var defaultAutowire:String;

	private var defaultDependencyCheck:String;

	private var defaultInitMethod:String;

	private var defaultDestroyMethod:String;
	
	private var defaultMerge:String;
	
	public function XmlBeanDefinitionParser(registry:BeanDefinitionRegistry) {
		this.registry = registry;
	}
	
	public function parse(beanDefinition:String, registry:BeanDefinitionRegistry):Void {
		if (this.registry == null) {
			if (registry == null) {
				throw new IllegalArgumentException("Argument 'registry' must not be 'null' nor 'undefined' if you did not specify a registry on construction of this instance.", this, arguments);
			}
			this.registry = registry;
		}
		var root:XMLNode = parseXml(beanDefinition);
		initDefaults(root);
		preProcessXml(root);
		parseBeanDefinitions(root);
		postProcessXml(root);
	}
	
	private function parseXml(beanDefinition:String):XMLNode {
		var xml:XML = new XML();
		xml.ignoreWhite = true;
		xml.parseXML(beanDefinition);
		if (xml.status != 0) {
			throw new BeanDefinitionStoreException(null, "Bean definition [" + beanDefinition + "] is syntactically malformed.", this, arguments);
		}
		return xml.lastChild;
	}
	
	/**
	 * Initialize the default lazy-init, autowire and dependency check settings.
	 *
	 * @see #setDefaultLazyInit
	 * @see #setDefaultAutowire
	 * @see #setDefaultDependencyCheck
	 */
	private function initDefaults(root:XMLNode):Void {
		defaultLazyInit = root.attributes[DEFAULT_LAZY_INIT_ATTRIBUTE];
		defaultAutowire = root.attributes[DEFAULT_AUTOWIRE_ATTRIBUTE];
		defaultDependencyCheck = root.attributes[DEFAULT_DEPENDENCY_CHECK_ATTRIBUTE];
		if (root.attributes[DEFAULT_INIT_METHOD_ATTRIBUTE] != null) {
			defaultInitMethod = root.attributes[DEFAULT_INIT_METHOD_ATTRIBUTE];
		}
		if (root.attributes[DEFAULT_DESTROY_METHOD_ATTRIBUTE] != null) {
			defaultDestroyMethod = root.attributes[DEFAULT_DESTROY_METHOD_ATTRIBUTE];
		}
		defaultMerge = root.attributes[DEFAULT_MERGE_ATTRIBUTE];
	}
	
	private function preProcessXml(root:XMLNode):Void {
	}
	
	/**
	 * Parses the elements at the root level in the document: "import", "alias", "bean".
	 *
	 * @param root the root node of the xml document
	 */
	private function parseBeanDefinitions(root:XMLNode):Void {
		var nodes:Array = root.childNodes;
		for (var i:Number = 0; i < nodes.length; i++) {
			parseElement(nodes[i]);
		}
	}
	
	private function parseElement(element:XMLNode):Void {
		if (ALIAS_ELEMENT == element.nodeName) {
			var name:String = element.attributes[NAME_ATTRIBUTE];
			var alias:String = element.attributes[ALIAS_ATTRIBUTE];
			registry.registerAlias(name, alias);
		}
		if (BEAN_ELEMENT == element.nodeName) {
			var holder:BeanDefinitionHolder = parseBeanDefinitionElement(element);
			registry.registerBeanDefinition(holder.getBeanName(), holder.getBeanDefinition());
			var aliases:Array = holder.getAliases();
			for (var i:Number = 0; i < aliases.length; i++) {
				registry.registerAlias(holder.getBeanName(), aliases[i]);
			}
		}
	}
	
	/**
	 * Parse a standard bean definition into a BeanDefinitionHolder,
	 * including bean name and aliases.
	 * <p>Bean elements specify their canonical name as "id" attribute
	 * and their aliases as a delimited "name" attribute.
	 * <p>If no "id" specified, uses the first name in the "name" attribute
	 * as canonical name, registering all others as aliases.
	 * <p>Callers should specify whether this element represents an inner bean
	 * definition or not by setting the <code>isInnerBean</code> argument appropriately
	 */
	private function parseBeanDefinitionElement(element:XMLNode):BeanDefinitionHolder {
		var id:String = element.attributes[ID_ATTRIBUTE];
		var name:String = element.attributes[NAME_ATTRIBUTE];
		var aliases:Array;
		if (name != null && name != "") {
			aliases = tokenizeToStringArray(name, BEAN_NAME_DELIMITERS);
		}
		var beanName:String = id;
		if ((beanName == "" || beanName == null) && aliases.length > 0) {
			beanName = aliases.shift().toString();
		}
		var beanDefinition:BeanDefinition = parseBeanDefinitionElementWithoutRegardToNameOrAliases(element, beanName);
		if (beanName == "" || beanName == null) {
			beanName = generateBeanName(beanDefinition);
		}
		return new BeanDefinitionHolder(beanDefinition, beanName, aliases);
	}
	
	private function parseBeanDefinitionElementWithoutRegardToNameOrAliases(element:XMLNode, beanName:String):BeanDefinition {
		var className:String = element.attributes[CLASS_ATTRIBUTE];
		var parent:String = element.attributes[PARENT_ATTRIBUTE];
		try {
			var cargs:ConstructorArgumentValues = parseConstructorArgElements(element, beanName);
			var pvs:PropertyValues = parsePropertyElements(element, beanName);
			var bd:AbstractBeanDefinition = createBeanDefinition(className, parent, cargs, pvs);
			var dependsOn:String = element.attributes[DEPENDS_ON_ATTRIBUTE];
			if (dependsOn != null) {
				bd.setDependsOn(tokenizeToStringArray(dependsOn, BEAN_NAME_DELIMITERS));
			}
			var factoryMethod:String = element.attributes[FACTORY_METHOD_ATTRIBUTE];
			if (factoryMethod != null) {
				bd.setFactoryMethodName(factoryMethod);
			}
			var factoryBean:String = element.attributes[FACTORY_BEAN_ATTRIBUTE];
			if (factoryBean != null) {
				bd.setFactoryBeanName(factoryBean);
			}
			var dependencyCheck:String = element.attributes[DEPENDENCY_CHECK_ATTRIBUTE];
			if (DEFAULT_VALUE == dependencyCheck) {
				dependencyCheck = defaultDependencyCheck;
			}
			bd.setDependencyCheck(getDependencyCheck(dependencyCheck));
			var autowire:String = element.attributes[AUTOWIRE_ATTRIBUTE];
			if (DEFAULT_VALUE == autowire) {
				autowire = defaultAutowire;
			}
			bd.setAutowireMode(getAutowireMode(autowire));
			var initMethodName:String = element.attributes[INIT_METHOD_ATTRIBUTE];
			if (initMethodName != null) {
				if (initMethodName != "") {
					bd.setInitMethodName(initMethodName);
				}
			}
			else {
				if (defaultInitMethod != null) {
					bd.setInitMethodName(defaultInitMethod);
					bd.setEnforceInitMethod(false);
				}
			}
			var destroyMethodName:String = element.attributes[DESTROY_METHOD_ATTRIBUTE];
			if (destroyMethodName != null) {
				if (destroyMethodName != "") {
					bd.setDestroyMethodName(destroyMethodName);
				}
			}
			else {
				if (defaultDestroyMethod != null) {
					bd.setDestroyMethodName(defaultDestroyMethod);
					bd.setEnforceDestroyMethod(false);
				}
			}
			parseLookupOverrideSubElements(element, beanName, bd.getMethodOverrides());
			parseReplacedMethodSubElements(element, beanName, bd.getMethodOverrides());
			var abstract:String = element.attributes[ABSTRACT_ATTRIBUTE];
			if (abstract != null) {
				bd.setAbstract(TRUE_VALUE == abstract);
			}
			var singleton:String = element.attributes[SINGLETON_ATTRIBUTE];
			if (singleton != null) {
				bd.setSingleton(TRUE_VALUE == singleton);
			}
			var lazyInit:String = element.attributes[LAZY_INIT_ATTRIBUTE];
			if (DEFAULT_VALUE == lazyInit && bd.isSingleton()) {
				// Just apply default to singletons, as lazy-init has no meaning for prototypes.
				lazyInit = defaultLazyInit;
			}
			bd.setLazyInit(TRUE_VALUE == lazyInit);
			return BeanDefinition(bd);
		}
		catch (exception:org.as2lib.bean.factory.BeanDefinitionStoreException) {
			throw exception;
		}
		catch (exception:org.as2lib.env.reflect.ClassNotFoundException) {
			throw (new BeanDefinitionStoreException(beanName, "Bean class [" + className + "] not found.", this, arguments)).initCause(exception);
		}
		catch (exception) {
			throw (new BeanDefinitionStoreException(beanName, "Unexpected failure during bean definition parsing.", this, arguments)).initCause(exception);
		}
	}
	
	/**
	 * Parse constructor-arg sub-elements of the given bean element.
	 */
	private function parseConstructorArgElements(beanElement:XMLNode, beanName:String):ConstructorArgumentValues {
		var result:ConstructorArgumentValues = new ConstructorArgumentValues();
		var nodes:Array = beanElement.childNodes;
		for (var i:Number = 0; i < nodes.length; i++) {
			var node:XMLNode = nodes[i];
			if (CONSTRUCTOR_ARG_ELEMENT == node.nodeName) {
				parseConstructorArgElement(node, beanName, result);
			}
		}
		return result;
	}
	
	/**
	 * Parse property sub-elements of the given bean element.
	 */
	private function parsePropertyElements(beanElement:XMLNode, beanName:String):PropertyValues {
		var result:PropertyValues = new PropertyValues();
		var nodes:Array = beanElement.childNodes;
		for (var i:Number = 0; i < nodes.length; i++) {
			var node:XMLNode = nodes[i];
			if (PROPERTY_ELEMENT == node.nodeName) {
				parsePropertyElement(node, beanName, result);
			}
		}
		return result;
	}
	
	/**
	 * Parse lookup-override sub-elements of the given bean element.
	 */
	private function parseLookupOverrideSubElements(beanElement:XMLNode, beanName:String, overrides:MethodOverrides):Void {
		var nodes = beanElement.childNodes;
		for (var i:Number = 0; i < nodes.length; i++) {
			var node:XMLNode = nodes[i];
			if (LOOKUP_METHOD_ELEMENT == node.nodeName) {
				var methodName:String = node.attributes[NAME_ATTRIBUTE];
				var beanReference:String = node.attributes[BEAN_ELEMENT];
				overrides.addOverride(new LookupOverride(methodName, beanReference));
			}
		}
	}
	
	/**
	 * Parse replaced-method sub-elements of the given bean element.
	 */
	private function parseReplacedMethodSubElements(beanElement:XMLNode, beanName:String, overrides:MethodOverrides) {
		var nodes:Array = beanElement.childNodes;
		for (var i:Number = 0; i < nodes.length; i++) {
			var node:XMLNode = nodes[i];
			if (REPLACED_METHOD_ELEMENT == node.nodeName) {
				var name:String = node.attributes[NAME_ATTRIBUTE];
				var callback:String = node.attributes[REPLACER_ATTRIBUTE];
				var replaceOverride:ReplaceOverride = new ReplaceOverride(name, callback);
				overrides.addOverride(replaceOverride);
			}
		}
	}

	/**
	 * Parse a constructor-arg element.
	 */
	private function parseConstructorArgElement(element:XMLNode, beanName:String, argumentValues:ConstructorArgumentValues):Void {
		var value = parsePropertyValue(element, beanName, null);
		var indexAttribute:String = element.attributes[INDEX_ATTRIBUTE];
		var typeAttribute:String = element.attributes[TYPE_ATTRIBUTE];
		var type:Function;
		if (typeAttribute != null && typeAttribute != "") {
			type = eval("_global." + typeAttribute);
			if (type == null) {
				throw new BeanDefinitionStoreException(beanName, "Type '" + typeAttribute + "' for constructor argument '" + indexAttribute + "' not found.", this, arguments);
			}
		}
		if (indexAttribute != null && indexAttribute != "") {
			if (isNaN(indexAttribute)) {
				throw new BeanDefinitionStoreException(beanName, "Attribute 'index' of tag 'constructor-arg' must be a number.", this, arguments);
			}
			var index:Number = Number(indexAttribute);
			if (index < 0) {
				throw new BeanDefinitionStoreException(beanName, "'index' cannot be lower than 0.", this, arguments);
			}
			argumentValues.addArgumentValue(index, new ConstructorArgumentValue(value, type));
		}
		else {
			argumentValues.addArgumentValue(new ConstructorArgumentValue(value, type));
		}
	}
	
	/**
	 * Parse a property element.
	 */
	private function parsePropertyElement(element:XMLNode, beanName:String, propertyValues:PropertyValues):Void {
		var propertyName:String = element.attributes[NAME_ATTRIBUTE];
		if (propertyName == null || propertyName == "") {
			throw new BeanDefinitionStoreException(beanName, "Tag 'property' must have a 'name' attribute.", this, arguments);
		}
		if (propertyValues.contains(propertyName)) {
			throw new BeanDefinitionStoreException(beanName, "Multiple 'property' definitions for property '" + propertyName + "'.", this, arguments);
		}
		var value = parsePropertyValue(element, beanName, propertyName);
		var typeName:String = element.attributes[TYPE_ATTRIBUTE];
		var type:Function;
		if (typeName != null && typeName != "") {
			type = eval("_global." + typeName);
			if (type == null) {
				throw new BeanDefinitionStoreException(beanName, "Type for type name '" + typeName + "' of property '" + propertyName + "' could not be found.", this, arguments);
			}
		}
		propertyValues.addPropertyValue(propertyName, value, type);
	}
	
	/**
	 * Get the value of a property element. May be a list etc.
	 * Also used for constructor arguments, "propertyName" being null in this case.
	 */
	private function parsePropertyValue(element:XMLNode, beanName:String, propertyName:String) {
		var elementName:String;
		if (propertyName == null) {
			elementName = "<constructor-arg> element";
		}
		else {
			elementName = "<property> element for property '" + propertyName + "'";
		}
		// Should only have one child element: ref, value, list, etc.
		var nodes = element.childNodes;
		var subElement:XMLNode;
		for (var i:Number = 0; i < nodes.length; i++) {
			var candidateElement:XMLNode = nodes[i];
			if (DESCRIPTION_ELEMENT != candidateElement.nodeName) {
				if (subElement != null) {
					throw new BeanDefinitionStoreException(beanName, elementName + " must not contain more than one sub-element.", this, arguments);
				}
				subElement = candidateElement;
			}
		}
		var refAttribute:String = element.attributes[REF_ATTRIBUTE];
		var valueAttribute:String = element.attributes[VALUE_ATTRIBUTE];
		if ((refAttribute != null && valueAttribute != null) ||
				((refAttribute != null || valueAttribute != null)) && subElement != null) {
			throw new BeanDefinitionStoreException(beanName, elementName + " is only allowed to contain either a 'ref' attribute or a 'value' attribute or a sub-element.", this, arguments);
		}
		if (refAttribute != null) {
			if (refAttribute == "") {
				throw new BeanDefinitionStoreException(beanName, elementName + " contains empty 'ref' attribute.", this, arguments);
			}
			return new RuntimeBeanReference(element.attributes[REF_ATTRIBUTE]);
		}
		if (valueAttribute != null) {
			return element.attributes[VALUE_ATTRIBUTE];
		}
		if (subElement == null) {
			// Neither child element nor "ref" or "value" attribute found.
			throw new BeanDefinitionStoreException(beanName, elementName + " must specify a ref or value.", this, arguments);
		}
		return parsePropertySubElement(subElement, beanName);
	}
	
	/**
	 * Parse a value, ref or collection sub-element of a property or
	 * constructor-arg element.
	 *
	 * @param ele subelement of property element; we don't know which yet
	 */
	private function parsePropertySubElement(element:XMLNode, beanName:String) {
		if (element.nodeName == BEAN_ELEMENT) {
			return parseBeanDefinitionElement(element);
		}
		if (element.nodeName == REF_ELEMENT) {
			// A generic reference to any name of any bean.
			var refName:String = element.attributes[BEAN_REF_ATTRIBUTE];
			var toParent:Boolean = false;
			if (refName == null || refName == "") {
				// A reference to the id of another bean in the same XML file.
				refName = element.attributes[LOCAL_REF_ATTRIBUTE];
				if (refName == null || refName == "") {
					// A reference to the id of another bean in a parent context.
					refName = element.attributes[PARENT_REF_ATTRIBUTE];
					toParent = true;
					if (refName == null || refName == "") {
						throw new BeanDefinitionStoreException(beanName, "'bean', 'local' or 'parent' is required for a reference.", this, arguments);
					}
					return new RuntimeBeanReference(refName, true);
				}
			}
			if (refName == null || refName == "") {
				throw new BeanDefinitionStoreException(beanName, "<ref> element contains empty target attribute", this, arguments);
			}
			return new RuntimeBeanReference(refName);
		}
		if (element.nodeName == IDREF_ELEMENT) {
			// A generic reference to any name of any bean.
			var beanRef:String = element.attributes[BEAN_REF_ATTRIBUTE];
			if (beanRef == null || beanRef == "") {
				// A reference to the id of another bean in the same XML file.
				beanRef = element.attributes[LOCAL_REF_ATTRIBUTE];
				if (beanRef == null || beanRef == "") {
					throw new BeanDefinitionStoreException(beanName, "Either 'bean' or 'local' is required for <idref> element.", this, arguments);
				}
			}
			return beanRef;
		}
		if (element.nodeName == VALUE_ELEMENT) {
			// It's a literal value.
			if (element.firstChild.nodeValue == null) {
				return "";
			}
			return element.firstChild.nodeValue;
		}
		if (element.nodeName == NULL_ELEMENT) {
			// It's a distinguished null value.
			return null;
		}
		if (element.nodeName == LIST_ELEMENT) {
			return parseListElement(element, beanName);
		}
		if (element.nodeName == MAP_ELEMENT) {
			return parseMapElement(element, beanName);
		}
		if (element.nodeName == PROPS_ELEMENT) {
			return parsePropsElement(element, beanName);
		}
		throw new BeanDefinitionStoreException(beanName, "Unknown property sub-element: <" + element.nodeName + ">.", this, arguments);
	}
	
	/**
	 * Parse a list element.
	 */
	private function parseListElement(collectionElement:XMLNode, beanName:String):List {
		var nodes:Array = collectionElement.childNodes;
		var list:ManagedList = new ManagedList();
		list.setMergeEnabled(parseMergeAttribute(collectionElement));
		for (var i:Number = 0; i < nodes.length; i++) {
			var node:XMLNode = nodes[i];
			list.insert(parsePropertySubElement(node, beanName));
		}
		return list;
	}
	
	/**
	 * Parse a map element.
	 */
	private function parseMapElement(mapElement:XMLNode, beanName:String):Map {
		var entryElements:Array = getChildElementsByTagName(mapElement, ENTRY_ELEMENT);
		var map:ManagedMap = new ManagedMap();
		map.setMergeEnabled(parseMergeAttribute(mapElement));
		for (var i:Number = 0; i < entryElements.length; i++) {
			var entryElement:XMLNode = entryElements[i];
			// Should only have one value child element: ref, value, list, etc.
			// Optionally, there might be a key child element.
			var entrySubNodes:Array = entryElement.childNodes;
			var keyElement:XMLNode;
			var valueElement:XMLNode;
			for (var j:Number = 0; j < entrySubNodes.length; j++) {
				var candidateElement:XMLNode = entrySubNodes[j];
				if (candidateElement.nodeName == KEY_ELEMENT) {
					if (keyElement != null) {
						throw new BeanDefinitionStoreException(beanName, "<entry> is only allowed to contain one <key> sub-element.", this, arguments);
					}
					keyElement = candidateElement;
				}
				else {
					// Child element is what we're looking for.
					if (valueElement != null) {
						throw new BeanDefinitionStoreException(beanName, "<entry> must not contain more than one value sub-element.", this, arguments);
					}
					valueElement = candidateElement;
				}
			}
			// Extract key from attribute or sub-element.
			var key;
			var keyAttribute:String = entryElement.attributes[KEY_ATTRIBUTE];
			var keyRefAttribute:String = entryElement.attributes[KEY_REF_ATTRIBUTE];
			if ((keyAttribute != null && keyRefAttribute != null) ||
					((keyAttribute != null || keyRefAttribute != null)) && keyElement != null) {
				throw new BeanDefinitionStoreException(beanName, "<entry> is only allowed to contain either " +
						"a 'key' attribute OR a 'key-ref' attribute OR a <key> sub-element.", this, arguments);
			}
			if (keyAttribute != null) {
				key = keyAttribute;
			}
			else if (keyRefAttribute != null) {
				if (keyRefAttribute == "") {
					throw new BeanDefinitionStoreException(beanName, "<entry> element contains empty 'key-ref' attribute.", this, arguments);
				}
				key = new RuntimeBeanReference(keyRefAttribute);
			}
			else if (keyElement != null) {
				key = parseKeyElement(keyElement, beanName);
			}
			else {
				throw new BeanDefinitionStoreException(beanName, "<entry> must specify a key.", this, arguments);
			}
			// Extract value from attribute or sub-element.
			var value = null;
			var valueAttribute:String = entryElement.attributes[VALUE_ATTRIBUTE];
			var valueRefAttribute:String = entryElement.attributes[VALUE_REF_ATTRIBUTE];
			if ((valueAttribute != null && valueRefAttribute != null) ||
					((valueAttribute != null || valueRefAttribute != null)) && valueElement != null) {
				throw new BeanDefinitionStoreException(beanName, "<entry> is only allowed to contain either " +
						"'value' attribute OR 'value-ref' attribute OR <value> sub-element.", this, arguments);
			}
			if (valueAttribute != null) {
				value = valueAttribute;
			}
			else if (valueRefAttribute != null) {
				if (valueRefAttribute == "") {
					throw new BeanDefinitionStoreException(beanName, "<entry> element contains empty 'value-ref' attribute.", this, arguments);
				}
				value = new RuntimeBeanReference(valueRefAttribute);
			}
			else if (valueElement != null) {
				value = parsePropertySubElement(valueElement, beanName);
			}
			else {
				throw new BeanDefinitionStoreException(beanName, "<entry> must specify a value.", this, arguments);
			}
			// Add final key and value to the Map.
			map.put(key, value);
		}
		return map;
	}
	
	/**
	 * Parse a key sub-element of a map element.
	 */
	private function parseKeyElement(keyElement:XMLNode, beanName:String) {
		var nodes:Array = keyElement.childNodes;
		var subElement:XMLNode;
		for (var i:Number = 0; i < nodes.length; i++) {
			var candidateElement:XMLNode = nodes[i];
			// Child element is what we're looking for.
			if (subElement != null) {
				throw new BeanDefinitionStoreException(beanName, "<key> must not contain more than one value sub-element.", this, arguments);
			}
			subElement = candidateElement;
		}
		return parsePropertySubElement(subElement, beanName);
	}
	
	/**
	 * Parse a props element.
	 */
	private function parsePropsElement(propsElement:XMLNode, beanName:String):Properties {
		var properties:ManagedProperties = new ManagedProperties();
		properties.setMergeEnabled(parseMergeAttribute(propsElement));
		var propElements:Array = getChildElementsByTagName(propsElement, PROP_ELEMENT);
		for (var i:Number = 0; i < propElements.length; i++) {
			var propElement:XMLNode = propElements[i];
			var key:String = propElement.attributes[KEY_ATTRIBUTE];
			// Trim the text value to avoid unwanted whitespace
			// caused by typical XML formatting.
			var value:String = TrimUtil.trim(propElement.firstChild.nodeValue);
			properties.setProp(key, value);
		}
		return properties;
	}
	
	/**
	 * Parse the merge attribute of a collection element, if any.
	 */
	private function parseMergeAttribute(collectionElement:XMLNode):Boolean {
		var value:String = collectionElement.attributes[MERGE_ATTRIBUTE];
		if (DEFAULT_VALUE == value) {
			value = defaultMerge;
		}
		return TRUE_VALUE == value;
	}
	
	private function getChildElementsByTagName(element:XMLNode, nodeName:String):Array {
		var result:Array = new Array();
		var nodes:Array = element.childNodes;
		for (var i:Number = 0; i < nodes.length; i++) {
			var node:XMLNode = nodes[i];
			if (node.nodeName == nodeName) {
				result.push(node);
			}
		}
		return result;
	}
	
	private function getDependencyCheck(attribute:String):Number {
		if (DEPENDENCY_CHECK_ALL_ATTRIBUTE_VALUE == attribute) {
			return AbstractBeanDefinition.DEPENDENCY_CHECK_ALL;
		}
		if (DEPENDENCY_CHECK_SIMPLE_ATTRIBUTE_VALUE == attribute) {
			return AbstractBeanDefinition.DEPENDENCY_CHECK_SIMPLE;
		}
		if (DEPENDENCY_CHECK_OBJECTS_ATTRIBUTE_VALUE == attribute) {
			return AbstractBeanDefinition.DEPENDENCY_CHECK_OBJECTS;
		}
		return AbstractBeanDefinition.DEPENDENCY_CHECK_NONE;
	}

	private function getAutowireMode(attribute:String):Number {
		if (AUTOWIRE_BY_NAME_VALUE == attribute) {
			return AbstractBeanDefinition.AUTOWIRE_BY_NAME;
		}
		return AbstractBeanDefinition.AUTOWIRE_NO;
	}
	
	/**
	 * Create a new RootBeanDefinition or ChildBeanDefinition for the given
	 * class name, parent, constructor arguments, and property values.
	 * @param className the name of the bean class, if any
	 * @param parent the name of the parent bean, if any
	 * @param cargs the constructor arguments, if any
	 * @param pvs the property values, if any
	 * @param classLoader the ClassLoader to use for loading bean classes
	 * (can be <code>null</code> to just register bean classes by name)
	 * @return the bean definition
	 * @throws ClassNotFoundException if the bean class could not be loaded
	 */
	public function createBeanDefinition(className:String, parent:String, constructorArgumentValues:ConstructorArgumentValues, propertyValues:PropertyValues):AbstractBeanDefinition {
		var beanClass:Function;
		if (className != null) {
			beanClass = eval("_global." + className);
			if (beanClass == null) {
				throw new ClassNotFoundException("Class with name '" + className + "' could not be found.", this, arguments);
			}
		}
		var result:AbstractBeanDefinition;
		if (parent == null) {
			result = new RootBeanDefinition(constructorArgumentValues, propertyValues);
		}
		else {
			result = new ChildBeanDefinition(parent, constructorArgumentValues, propertyValues);
		}
		result.setBeanClass(beanClass);
		result.setBeanClassName(className);
		return result;
	}
	
	/**
	 * Generate a bean name for the given bean definition, unique within the
	 * given bean factory.
	 * @param beanDefinition the bean definition to generate a bean name for
	 * @param beanFactory the bean factory that the definition is going to be
	 * registered with (to check for existing bean names)
	 * @param isInnerBean whether the given bean definition will be registered
	 * as inner bean or as top-level bean (allowing for special name generation
	 * for inner beans vs. top-level beans)
	 * @return the bean name to use
	 * @throws BeanDefinitionStoreException if no unique name can be generated
	 * for the given bean definition
	 */
	private function generateBeanName(beanDefinition:BeanDefinition):String {
		var generatedId:String = beanDefinition.getBeanClassName();
		if (generatedId == null) {
			if (beanDefinition instanceof ChildBeanDefinition) {
				generatedId = ChildBeanDefinition(beanDefinition).getParentName() + "$child";
			}
			else if (beanDefinition.getFactoryBeanName() != null) {
				generatedId = beanDefinition.getFactoryBeanName() + "$created";
			}
		}
		if (generatedId == null || generatedId == "") {
			throw new BeanDefinitionStoreException(null, "Unnamed bean definition specifies neither 'class' nor 'parent' nor 'factory-bean' - can't generate bean name.", this, arguments);
		}
		// Top-level bean: use plain class name. If not already unique,
		// add counter - increasing the counter until the name is unique.
		var counter:Number = 0;
		var id:String = generatedId;
		while (registry.containsBeanDefinition(id)) {
			counter++;
			id = generatedId + GENERATED_BEAN_NAME_SEPARATOR + counter;
		}
		return id;
	}
	
	private function tokenizeToStringArray(string:String, delimiters:String):Array {
		var length:Number = BEAN_NAME_DELIMITERS.length - 1;
		var character:String = BEAN_NAME_DELIMITERS.charAt(length);
		for (var i:Number = 0; i < length; i++) {
			string = StringUtil.replace(string, BEAN_NAME_DELIMITERS.charAt(i), character);
		}
		return string.split(character);
	}
	
	private function postProcessXml(root:XMLNode):Void {
	}
	
}