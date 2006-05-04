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
import org.as2lib.bean.factory.config.RuntimeBeanReference;
import org.as2lib.bean.factory.parser.StyleSheetParser;
import org.as2lib.bean.factory.support.RootBeanDefinition;
import org.as2lib.bean.PropertyValue;
import org.as2lib.bean.PropertyValues;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.util.StringUtil;
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
	
	private var styles:Array;
	
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
		parseStyleSheet(cascadingStyleSheet);
		var beanNames:Array = factory.getBeanDefinitionNames();
		for (var i:Number = 0; i < beanNames.length; i++) {
			var beanName:String = beanNames[i];
			var beanDefinition:BeanDefinition = factory.getBeanDefinition(beanName);
			applyStyleSheet(beanDefinition, beanName, new Array());
		}
	}
	
	private function parseStyleSheet(styleSheet:String):Void {
		var sheet:StyleSheet = new StyleSheet();
		// TODO Find a less error-prone and faster algorithm.
		var ss:String = "";
		var oi:Number = styleSheet.indexOf("{");
		var ci:Number = -1;
		while (oi != -1) {
			var selectors:Array = styleSheet.substring(ci + 1, oi).split(",");
			for (var i:Number = 0; i < selectors.length; i++) {
				if (i != 0) {
					ss += ",";
				}
				ss += StringUtil.replace(TrimUtil.trim(selectors[i]), " ", "+");
			}
			ci = styleSheet.indexOf("}", oi);
			ss += styleSheet.substring(oi, ci + 1);
			oi = styleSheet.indexOf("{", ci);
		}
		if (!sheet.parseCSS(ss)) {
			throw new BeanDefinitionStoreException(null, "Cascading style sheet [" + styleSheet +
					"] is syntactically malformed.", this, arguments);
		}
		styles = new Array();
		var styleNames:Array = sheet.getStyleNames();
		for (var i:Number = 0; i < styleNames.length; i++) {
			var styleName:String = styleNames[i];
			if (styleName == NAMESPACE_SELECTOR) {
				namespaces = sheet.getStyle(NAMESPACE_SELECTOR);
			}
			else {
				var nameTokens:Array = styleName.split("+");
				var specificity:Number = computeSpecificity(nameTokens);
				var lastToken:String = nameTokens.pop().toString();
				if (styles[lastToken] == null) {
					styles[lastToken] = new Array();
				}
				var nameStyles:Array = styles[lastToken];
				if (nameStyles.length == 0) {
					nameStyles.push({name: nameTokens, style: sheet.getStyle(styleName), specificity: specificity});
				}
				else {
					for (var j:Number = nameStyles.length - 1; j >= 0; j--) {
						var nameStyle = nameStyles[j];
						if (nameStyle.specificity <= specificity) {
							nameStyles.splice(j + 1, 0, {name: nameTokens, style: sheet.getStyle(styleName), specificity: specificity});
							break;
						}
						else if (j == 0) {
							nameStyles.push({name: nameTokens, style: sheet.getStyle(styleName), specificity: specificity});
						}
					}
				}
			}
		}
	}
	
	private function computeSpecificity(selectors:Array):Number {
		var result:Number = 0;
		for (var i:Number = 0; i < selectors.length; i++) {
			var selector:String = selectors[i];
			var firstChar:String = selector.charAt(0);
			if (firstChar == ID_SELECTOR_PREFIX) {
				result += 100;
			}
			else if (firstChar == CLASS_SELECTOR_PREFIX) {
				result += 10;
			}
			else {
				result += 1;
			}
		}
		return result;
	}
	
	private function applyStyleSheet(beanDefinition:BeanDefinition, beanName:String, parentBeanDefinitions:Array):Void {
		applyTypeStyle(beanDefinition, parentBeanDefinitions);
		applyClassStyle(beanDefinition, parentBeanDefinitions);
		if (beanName != null) {
			applyIdStyle(beanDefinition, beanName, factory.getAliases(beanName), parentBeanDefinitions);
		}
		var values:Array = beanDefinition.getPropertyValues().getPropertyValues();
		for (var i:Number = 0; i < values.length; i++) {
			var propertyValue:PropertyValue = values[i];
			var holder:BeanDefinitionHolder = BeanDefinitionHolder(propertyValue.getValue());
			if (holder != null) {
				var pbd:Array = addParentBeanDefinition(parentBeanDefinitions, beanName, beanDefinition);
				applyStyleSheet(holder.getBeanDefinition(), null, pbd);
				continue;
			}
			var reference:RuntimeBeanReference = RuntimeBeanReference(propertyValue.getValue());
			if (reference != null) {
				var pbd:Array = addParentBeanDefinition(parentBeanDefinitions, beanName, beanDefinition);
				var rn:String = reference.getBeanName();
				var rb:BeanDefinition = factory.getBeanDefinition(rn, true);
				applyStyleSheet(rb, rn, pbd);
			}
		}
	}
	
	private function addParentBeanDefinition(parentBeanDefinitions:Array, beanName:String, beanDefinition:BeanDefinition):Array {
		var result:Array = parentBeanDefinitions.concat();
		if (beanName == null) {
			result.push(beanDefinition);
		}
		else {
			result.push(beanName);
		}
		return result;
	}
	
	private function applyTypeStyle(beanDefinition:BeanDefinition, parentBeanDefinitions:Array):Void {
		var styleName:String = getTypeStyleName(beanDefinition);
		applyStyles(beanDefinition, resolveStyles(styleName, parentBeanDefinitions));
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
	
	private function getTypeStyleName(beanDefinition:BeanDefinition):String {
		var source:XMLNode = beanDefinition.getSource();
		if (source != null) {
			var namespace:String = source["namespaceURI"];
			if (namespace == "" || namespace == null) {
				return source.nodeName;
			}
			else {
				return source["localName"];
			}
		}
		return null;
	}
	
	private function applyClassStyle(beanDefinition:BeanDefinition, parentBeanDefinitions:Array):Void {
		var styleName:String = getClassStyleName(beanDefinition);
		applyStyles(beanDefinition, resolveStyles(styleName, parentBeanDefinitions));
	}
	
	private function getClassStyleName(beanDefinition:BeanDefinition):String {
		var styleName:String = beanDefinition.getStyleName();
		if (styleName != null) {
			return (CLASS_SELECTOR_PREFIX + styleName);
		}
		return null;
	}
	
	private function applyIdStyle(beanDefinition:BeanDefinition, beanName:String, aliases:Array, parentBeanDefinitions:Array):Void {
		applyStyles(beanDefinition, resolveStyles(ID_SELECTOR_PREFIX + beanName, parentBeanDefinitions));
		for (var i:Number = 0; i < aliases.length; i++) {
			applyStyles(beanDefinition, resolveStyles(ID_SELECTOR_PREFIX + aliases[i], parentBeanDefinitions));
		}
	}
	
	private function resolveStyles(styleName:String, parentBeanDefinitions:Array):Array {
		var result:Array = new Array();
		var sa:Array = styles[styleName];
		if (sa != null) {
			for (var i:Number = sa.length - 1; i >= 0; i--) {
				var na:Array = sa[i].name;
				if (na.length == 0) {
					result.push(sa[i].style);
				}
				else {
					if (matches(na, parentBeanDefinitions)) {
						result.push(sa[i].style);
					}
				}
			}
		}
		return result;
	}
	
	private function matches(na:Array, parentBeanDefinitions:Array):Boolean {
		var nl:Number = na.length;
		var pl:Number = parentBeanDefinitions.length;
		if (nl <= pl) {
			for (var i:Number = nl - 1, j:Number = pl - 1; i >= 0, j >= 0; i--, j--) {
				var n:String = na[i];
				var success:Boolean = false;
				do {
					var pbd = parentBeanDefinitions[j];
					var parentBeanName:String;
					var parentBeanDefinition:BeanDefinition;
					if (typeof(pbd) == "string") {
						parentBeanName = pbd;
						parentBeanDefinition = factory.getBeanDefinition(pbd, true);
					}
					else {
						parentBeanDefinition = pbd;
					}
					if (matchesBeanDefinition(n, parentBeanDefinition, parentBeanName)) {
						success = true;
						break;
					}
					j--;
				}
				while (j >= 0);
				if (!success) {
					return false;
				}
			}
		}
		else {
			return false;
		}
		return true;
	}
	
	private function matchesBeanDefinition(styleName:String, beanDefinition:BeanDefinition, beanName:String):Boolean {
		var fc:String = styleName.charAt(0);
		if (fc == ".") {
			var csn:String = getClassStyleName(beanDefinition);
			if (styleName != csn) {
				return false;
			}
		}
		else if (fc == "#") {
			if (beanName != null) {
				if (ID_SELECTOR_PREFIX + beanName != styleName) {
					var success:Boolean = false;
					var aliases:Array = factory.getAliases(beanName);
					if (aliases != null) {
						for (var i:Number = 0; i < aliases.length; i++) {
							if (ID_SELECTOR_PREFIX + aliases[i] == beanName) {
								success = true;
								break;
							}
						}
					}
					if (!success) {
						return false;
					}
				}
			}
			else {
				return false;
			}
		}
		else {
			var tsn:String = getTypeStyleName(beanDefinition);
			if (styleName != tsn) {
				return false;
			}
		}
		return true;
	}
	
	private function applyStyles(beanDefinition, styles:Array):Void {
		for (var i:Number = 0; i < styles.length; i++) {
			applyStyle(beanDefinition, styles[i]);
		}
	}
	
	private function applyStyle(beanDefinition:BeanDefinition, style:Object):Void {
		if (style != null) {
			var pv:PropertyValues = beanDefinition.getPropertyValues();
			for (var i:String in style) {
				if (!pv.contains(i)) {
					var value:String = parsePropertyValue(style[i]);
					pv.addPropertyValueByIndexAndPropertyValue(0, new PropertyValue(i, value));
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
		// TODO There may be a sub-property which may also use value delimiters.
		var values:Array = value.substring(prefixIndex + 1, suffixIndex).split(VALUE_DELIMITER);
		var cav:ConstructorArgumentValues = new ConstructorArgumentValues();
		var pv:PropertyValues = new PropertyValues();
		for (var i:Number = 0; i < values.length; i++) {
			var va:String = TrimUtil.trim(values[i]);
			// TODO No clean solution. Does not work for more than 2-level wrapping.
			if (va.indexOf("(") != -1) {
				while (values[i].indexOf(")") == -1) {
					va += VALUE_DELIMITER + values[++i];
				}
			}
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