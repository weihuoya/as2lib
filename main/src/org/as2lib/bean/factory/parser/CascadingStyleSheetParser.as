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

import org.as2lib.bean.BeanUtil;
import org.as2lib.bean.factory.BeanDefinitionStoreException;
import org.as2lib.bean.factory.config.BeanDefinition;
import org.as2lib.bean.factory.config.BeanDefinitionHolder;
import org.as2lib.bean.factory.config.ConfigurableListableBeanFactory;
import org.as2lib.bean.factory.config.ConstructorArgumentValue;
import org.as2lib.bean.factory.config.ConstructorArgumentValues;
import org.as2lib.bean.factory.parser.StyleSheetParser;
import org.as2lib.bean.factory.support.RootBeanDefinition;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.util.TrimUtil;

import TextField.StyleSheet;

/**
 * {@code CascadingStyleSheetParser} parses cascading style sheets and formats bean
 * definitions with the read styles.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.parser.CascadingStyleSheetParser extends BasicClass implements
		StyleSheetParser {
	
	/** The delimiter to delimit multiple values. */
	public static var VALUE_DELIMITER:String = ",";
	
	/** Separates the namespace from the class name. */
	public static var NAMESPACE_SEPARATOR:String = "|";
	
	/** Separates the property name from the property value. */
	public static var NAME_VALUE_SEPARATOR:String = "=";
	
	public static var NAMESPACE_SELECTOR:String = "@namespace";
	
	public static var CLASS_SELECTOR_PREFIX:String = ".";
	public static var ID_SELECTOR_PREFIX:String = "#";
	
	/**
	 * Separator for generated bean names. If a class name is not unique, "#1", "#2"
	 * etc. will be appended, until the name becomes unique.
	 */
	public static var GENERATED_BEAN_NAME_SEPARATOR:String = "#";
	
	private var factory:ConfigurableListableBeanFactory;
	
	private var defaultFactory:ConfigurableListableBeanFactory;
	
	private var styleSheet:StyleSheet;
	
	private var namespaces;
	
	/**
	 * Constructs a new {@code CascadingStyleSheetParser} instance.
	 * 
	 * @param defaultFactory the default factory to use if none is passed-to the
	 * {@code parse} method
	 */
	public function CascadingStyleSheetParser(defaultFactory:ConfigurableListableBeanFactory) {
		this.defaultFactory = defaultFactory;
	}
	
	/**
	 * Parses the given cascading style sheet and formats the bean definitions
	 * registered at the given or the default factory with the parsed styles.
	 * 
	 * @param cascadingStyleSheet the cascading style sheet to parse
	 * @param factory the factory containing the bean definitions to format
	 * @throws IllegalArgumentException if neither {@code factory} has been specified
	 * nor the default factory on instantiation
	 */
	public function parse(cascadingStyleSheet:String, factory:ConfigurableListableBeanFactory):Void {
		if (factory == null) {
			if (defaultFactory == null) {
				throw new IllegalArgumentException("Argument 'factory' must not be 'null' nor " +
						"'undefined' if you did not specify a default factory on construction " +
						"of this bean definition parser.", this, arguments);
			}
			this.factory = defaultFactory;
		}
		else {
			this.factory = factory;
		}
		styleSheet = parseStyleSheet(cascadingStyleSheet);
		initNamespaces();
		var beanNames:Array = factory.getBeanDefinitionNames();
		for (var i:Number = 0; i < beanNames.length; i++) {
			var beanName:String = beanNames[i];
			var beanDefinition:BeanDefinition = factory.getBeanDefinition(beanName);
			parseStyles(beanDefinition, beanName);
		}
	}
	
	private function parseStyleSheet(styleSheet:String):StyleSheet {
		var result:StyleSheet = new StyleSheet();
		if (!result.parseCSS(styleSheet)) {
			throw new BeanDefinitionStoreException(null, "Cascading style sheet [" + styleSheet +
					"] is syntactically malformed.", this, arguments);
		}
		return result;
	}
	
	private function initNamespaces(Void):Void {
		namespaces = styleSheet.getStyle(NAMESPACE_SELECTOR);
	}
	
	private function parseStyles(beanDefinition:BeanDefinition, beanName:String):Void {
		parseTypeStyle(beanDefinition);
		parseClassStyle(beanDefinition);
		if (beanName != null) {
			parseIdStyle(beanDefinition, beanName, factory.getAliases(beanName));
		}
		var values:Array = beanDefinition.getPropertyValues().getPropertyValues();
		for (var i:Number = 0; i < values.length; i++) {
			var propertyValue:PropertyValue = values[i];
			var holder:BeanDefinitionHolder = BeanDefinitionHolder(propertyValue.getValue());
			if (holder != null) {
				parseStyles(holder.getBeanDefinition());
			}
		}
	}
	
	private function parseTypeStyle(beanDefinition:BeanDefinition):Void {
		var source:XMLNode = beanDefinition.getSource();
		if (source != null) {
			var styleName:String;
			var namespace:String = source["namespaceURI"];
			if (namespace == "" || namespace == null) {
				styleName = source.nodeName;
			}
			else {
				styleName = source["localName"];
			}
			parseStyle(beanDefinition, styleSheet.getStyle(styleName));
		}
		/*
		var className:String = beanDefinition.getBeanClassName();
		if (className == null) {
			var cbd:ChildBeanDefinition = ChildBeanDefinition(beanDefinition);
			var pbd:BeanDefinition = beanFactory.getBeanDefinition(cbd.getParentName());
			while (pbd != null) {
				var parentName:String = childBeanDefinition.getParentName();
				var className:String = 
			}
		}
		*/
	}
	
	private function parseClassStyle(beanDefinition:BeanDefinition):Void {
		var styleName:String = beanDefinition.getStyleName();
		parseStyle(beanDefinition, styleSheet.getStyle(CLASS_SELECTOR_PREFIX + styleName));
	}
	
	private function parseIdStyle(beanDefinition:BeanDefinition, beanName:String, aliases:Array):Void {
		parseStyle(beanDefinition, styleSheet.getStyle(ID_SELECTOR_PREFIX + beanName));
		for (var i:Number = 0; i < aliases.length; i++) {
			parseStyle(beanDefinition, styleSheet.getStyle(ID_SELECTOR_PREFIX + aliases[i]));
		}
	}
	
	private function parseStyle(beanDefinition:BeanDefinition, style:Object):Void {
		if (style != null) {
			var pv:PropertyValues = beanDefinition.getPropertyValues();
			for (var i:String in style) {
				if (!pv.contains(i)) {
					var value:String = parsePropertyValue(style[i]);
					pv.addPropertyValueByNameAndValueAndType(i, value);
				}
			}
		}
	}
	
	private function parsePropertyValue(value:String) {
		var variablePrefix:Number = value.indexOf("v[");
		if (variablePrefix == 0) {
			var variableSuffix:Number = value.lastIndexOf("]");
			if (variableSuffix == value.length - 1) {
				return parseStaticVariableValue(value, variablePrefix, variableSuffix);
			}
		}
		var beanPrefix:Number = value.indexOf("(");
		if (beanPrefix != -1) {
			var beanSuffix:Number = value.lastIndexOf(")");
			if (beanSuffix == value.length - 1) {
				return parseBeanDefinitionValue(value, beanPrefix, beanSuffix);
			}
		}
		return BeanUtil.convertValue(value);
	}
	
	private function parseStaticVariableValue(value:String, prefixIndex:Number, suffixIndex:Number) {
		var name:String = TrimUtil.trim(value.substring(prefixIndex + 2, suffixIndex));
		var result = eval("_global." + name);
		if (result === undefined) {
			throw new BeanDefinitionStoreException(null, "Static variable [" + name + "] does " +
					"not exist or is not yet initialized.", this, arguments);
		}
		return result;
	}
	
	private function parseBeanDefinitionValue(value:String, prefixIndex:Number, suffixIndex:Number):BeanDefinitionHolder {
		var className:String = parseClassName(value.substring(0, prefixIndex));
		var clazz:Function = findClass(className);
		var values:Array = value.substring(prefixIndex + 1, suffixIndex).split(VALUE_DELIMITER);
		var cav:ConstructorArgumentValues = new ConstructorArgumentValues();
		var pv:PropertyValues = new PropertyValues();
		for (var i:Number = 0; i < values.length; i++) {
			var va:String = TrimUtil.trim(values[i]);
			var separatorIndex:Number = va.indexOf(NAME_VALUE_SEPARATOR);
			if (separatorIndex == -1) {
				parseConstructorArg(va, cav);
			}
			else {
				parseProperty(va, separatorIndex, pv);
			}
		}
		var beanDefinition:RootBeanDefinition = new RootBeanDefinition(cav, pv);
		beanDefinition.setBeanClass(clazz);
		beanDefinition.setBeanClassName(className);
		return new BeanDefinitionHolder(beanDefinition, generateBeanName(beanDefinition));
	}
	
	private function parseClassName(className:String):String {
		var result:String = TrimUtil.trim(className);
		var separatorIndex:Number = result.indexOf(NAMESPACE_SEPARATOR);
		if (separatorIndex != -1) {
			var ns:String = result.substring(0, separatorIndex);
			var cn:String = result.substring(separatorIndex + 1);
			var namespaceUri:String = namespaces[ns];
			if (namespaceUri == null) {
				throw new BeanDefinitionStoreException(null, "Namespace [" + ns + "] does not " +
						"exist.", this, arguments);
			}
			result = namespaceUri + "." + cn;
		}
		return result;
	}
	
	private function findClass(className:String):Function {
		try {
			return BeanUtil.findClass(className);
		}
		catch (exception:org.as2lib.env.reflect.ClassNotFoundException) {
			throw (new BeanDefinitionStoreException(null, "Bean class [" + className + "] not " +
					"found.", this, arguments)).initCause(exception);
		}
	}
	
	private function parseConstructorArg(value:String, argumentValues:ConstructorArgumentValues):Void {
		var av:ConstructorArgumentValue = new ConstructorArgumentValue(parsePropertyValue(value));
		argumentValues.addArgumentValueByValue(av);
	}
	
	private function parseProperty(property:String, separatorIndex:Number, propertyValues:PropertyValues):Void {
		var name:String = TrimUtil.trim(property.substring(0, separatorIndex));
		var value:String = TrimUtil.trim(property.substring(separatorIndex + 1));
		propertyValues.addPropertyValueByNameAndValueAndType(name, parsePropertyValue(value));
	}
	
	/**
	 * Generates a bean name for the given bean definition, unique within the bean
	 * factory.
	 * 
	 * @param beanDefinition the bean definition to generate a bean name for
	 * @return the bean name to use
	 */
	private function generateBeanName(beanDefinition:BeanDefinition):String {
		var generatedId:String = beanDefinition.getBeanClassName();
		var counter:Number = 0;
		var id:String = generatedId;
		while (factory.containsBeanDefinition(id)) {
			counter++;
			id = generatedId + GENERATED_BEAN_NAME_SEPARATOR + counter;
		}
		return id;
	}
	
}