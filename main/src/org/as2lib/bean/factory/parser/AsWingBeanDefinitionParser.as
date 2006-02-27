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

import org.as2lib.bean.factory.parser.UiBeanDefinitionParser;
import org.as2lib.bean.factory.support.BeanDefinitionRegistry;
import org.as2lib.util.TextUtil;
import org.as2lib.util.TrimUtil;
import org.aswing.geom.Dimension;
import org.aswing.geom.Point;

/**
 * {@code AsWingBeanDefinitionParser} is based on the xml bean definition parser, but
 * adds special support for size- and location-properties. These properties are:
 * "size", "minimumSize", "maximumSize", "preferredSize", "location" and "globalLocation".
 * 
 * <p>The following example sets the width of the containing bean to {@code 120} and
 * the height to {@code 200}.
 * <code>
 *   &lt;property name="size"&gt;120, 200&lt;/property&gt;
 * </code>
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.parser.AsWingBeanDefinitionParser extends UiBeanDefinitionParser {
	
	public static var DIMENSION_CLASS_NAME:String = "org.aswing.geom.Dimension";
	
	public static var POINT_CLASS_NAME:String = "org.aswing.geom.Point";
	
	public static var SIZE_ATTRIBUTE:String = "size";
	
	public static var WIDTH_ATTRIBUTE:String = "width";
	
	public static var HEIGHT_ATTRIBUTE:String = "height";
	
	/**
	 * Constructs a new {@code XmlBeanDefinitionParser} instance.
	 * 
	 * @param registry the registry to use if none is passed-to in the {@code parse}
	 * method
	 */
	public function AsWingBeanDefinitionParser(registry:BeanDefinitionRegistry) {
		super(registry);
		// forces inclusion of classes Dimension and Point
		var d:Function = Dimension;
		var p:Function = Point;
	}
	
	private function getDefaultPropertyName(counter:Number):String {
		return "insert[" + counter + "]";
	}
	
	private function convertAttributeToPropertyElement(attribute:String, element:XMLNode):Void {
		// TODO: Refactor!
		var lowerCaseAttribute:String = attribute.toLowerCase();
		if (lowerCaseAttribute.indexOf(WIDTH_ATTRIBUTE) != -1
				|| lowerCaseAttribute.indexOf(HEIGHT_ATTRIBUTE) != -1) {
			if (element.attributes[attribute] != null) {
				var index:Number = lowerCaseAttribute.indexOf(HEIGHT_ATTRIBUTE);
				if (index == -1) {
					index = lowerCaseAttribute.indexOf(WIDTH_ATTRIBUTE);
				}
				var prefix:String = lowerCaseAttribute.substring(0, index);
				var propertyName:String = generatePropertyName(prefix, SIZE_ATTRIBUTE);
				var sizeProperty:XMLNode = createPropertyElement(propertyName);
				var sizeBean:XMLNode = new XMLNode(1, BEAN_ELEMENT);
				sizeBean.attributes[CLASS_ATTRIBUTE] = DIMENSION_CLASS_NAME;
				var widthAttribute:String = generatePropertyName(prefix, WIDTH_ATTRIBUTE);
				var widthValue:String = element.attributes[widthAttribute];
				if (widthValue == null || widthValue == "") {
					widthValue = "0";
				}
				sizeBean.appendChild(createConstructorArgumentElement(widthValue));
				var heightAttribute:String = generatePropertyName(prefix, HEIGHT_ATTRIBUTE);
				var heightValue:String = element.attributes[heightAttribute];
				if (heightValue == null || heightValue == "") {
					heightValue = "0";
				}
				sizeBean.appendChild(createConstructorArgumentElement(heightValue));
				sizeProperty.appendChild(sizeBean);
				element.appendChild(sizeProperty);
				delete element.attributes[widthAttribute];
				delete element.attributes[heightAttribute];
				return;
			}
		}
		else {
			super.convertAttributeToPropertyElement(attribute, element);
		}
	}
	
	private function generatePropertyName(prefix:String, base:String):String {
		if (prefix != "") {
			return (prefix + TextUtil.ucFirst(base));
		}
		return base;
	}
	
	/*private function preProcessXml(root:XMLNode):Void {
		var nodes:Array = root.childNodes;
		for (var i:Number = 0; i < nodes.length; i++) {
			var node:XMLNode = nodes[i];
			var childNodes:Array = node.childNodes;
			for (var j:Number = 0; j < childNodes.length; j++) {
				var childNode:XMLNode = childNodes[j];
				if (childNode.nodeName == PROPERTY_ELEMENT) {
					var name:String = childNode.attributes[NAME_ATTRIBUTE];
					if (name == "size" || name == "minimumSize" || name == "maximumSize" || name == "preferredSize") {
						replaceLiteralValueWithBeanElement(node, childNode, "org.aswing.geom.Dimension");
					}
					else if (name == "location" || name == "globalLocation") {
						replaceLiteralValueWithBeanElement(node, childNode, "org.aswing.geom.Point");
					}
				}
				// TODO: Further pre-processing must not be done if sub-node is one of the above special cases
				preProcessXml(childNode);
			}
		}
	}
	
	private function replaceLiteralValueWithBeanElement(parentElement:XMLNode, propertyElement:XMLNode, className:String):Void {
		if (propertyElement.firstChild.nodeType == 3) {
			var values:Array = propertyElement.firstChild.nodeValue.split(",");
			var newPropertyElement:XMLNode = new XMLNode(1, PROPERTY_ELEMENT);
			newPropertyElement.attributes[NAME_ATTRIBUTE] = propertyElement.attributes[NAME_ATTRIBUTE];
			var beanElement:XMLNode = new XMLNode(1, BEAN_ELEMENT);
			beanElement.attributes[CLASS_ATTRIBUTE] = className;
			beanElement.appendChild(createConstructorArgumentElement(values[0]));
			beanElement.appendChild(createConstructorArgumentElement(values[1]));
			newPropertyElement.appendChild(beanElement);
			parentElement.insertBefore(newPropertyElement, propertyElement);
			propertyElement.removeNode();
		}
	}*/
	
	private function createConstructorArgumentElement(value:String):XMLNode {
		var result:XMLNode = new XMLNode(1, CONSTRUCTOR_ARG_ELEMENT);
		var textNode:XMLNode = new XMLNode(3, TrimUtil.trim(value));
		result.appendChild(textNode);
		return result;
	}
	
}