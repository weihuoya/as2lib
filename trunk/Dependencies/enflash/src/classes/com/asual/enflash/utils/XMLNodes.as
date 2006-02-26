class com.asual.enflash.utils.XMLNodes {

	/**
	 * Formats an XML object to a tabulated string representation.
	 * 
	 * @param node The XML node that will be formatted
	 * @param tab (optional) Initial tabbing 
	 * @return The formatted XML string 
	 */
	public static function format(node:XMLNode, tab:String):String {

		var output:String = "";
		if (tab == undefined) tab = "";
	
		if (node.nodeType != 3) {
	
			if (node.nodeName != null) {
	
				output += tab + "<" + node.nodeName;
				for (var attr in node.attributes){
					output += " " + attr + "=\"" + node.attributes[attr] + "\"";
				}
				if (node.firstChild != null) {
					output += ">\n" + format(node.firstChild, tab + "\t") + "\n" + tab + "</" + node.nodeName + ">";
				} else {
					output += " />";
				}

			} else {
				output += format(node.firstChild, tab);
			}
		}

		if (node.nextSibling != null) {
			output += "\n" + format(node.nextSibling, tab);
		}
		if (XML(node).xmlDecl != undefined) {
			output = XML(node).xmlDecl + "\n" + output;
		}
	
		return output;
	}

	/**
	 * Simple search utility that provides a node with a given name.
	 * 
	 * @param node The XML node that will be searched
	 * @param name The name of the node that has to be found
	 * @param direction (optional) Specifies the firstChild/nextSibling priority of a match finding
	 * @return The XML node with such a name
	 */	
	public static function getByName(node:XMLNode, name:String, direction:Boolean):XMLNode {
		
		if (node.nodeName == name) {
			return node;
		} else {
			var firstChild = (node.firstChild != null) ? getByName(node.firstChild, name, direction) : null;
			var nextSibling = (node.nextSibling != null) ? getByName(node.nextSibling, name, direction) : null;
			return (direction) ? (firstChild || nextSibling) : (nextSibling || firstChild);
		}
	}

	/**
	 * Simple search utility that provides a node with a given value.
	 * 
	 * @param node The XML node that will be searched
	 * @param value The value of the node that has to be found
	 * @param direction (optional) Specifies the firstChild/nextSibling priority of a match finding
	 * @return The XML node with such a value
	 */
	public static function getByValue(node:XMLNode, value:String, direction:Boolean):XMLNode {
		
		if (node.nodeValue == value) {
			return node;
		} else {
			var firstChild = (node.firstChild != null) ? getByValue(node.firstChild, value, direction) : null;
			var nextSibling = (node.nextSibling != null) ? getByValue(node.nextSibling, value, direction) : null;
			return (direction) ? (firstChild || nextSibling) : (nextSibling || firstChild);
		}
	}

	/**
	 * Search utility that provides a node that has an attribute with a given value.
	 * 
	 * @param node The XML node that will be searched
	 * @param name The name of the attribute
	 * @param value The value of the attribute
	 * @param direction (optional) Specifies the firstChild/nextSibling priority of a match finding
	 * @return The XML node with such an attribute
	 */
	public static function getByAttribute(node:XMLNode, name:String, value:String, direction:Boolean):XMLNode {
		
		if (node.attributes[name] == value) {
			return node;
		} else {
			var firstChild = (node.firstChild != null) ? getByAttribute(node.firstChild, name, value, direction) : null;
			var nextSibling = (node.nextSibling != null) ? getByAttribute(node.nextSibling, name, value, direction) : null;
			return (direction) ? (firstChild || nextSibling) : (nextSibling || firstChild);
		}
	}

	/**
	 * Search utility that provides a node with a give name and a specific attribute value.
	 * 
	 * @param node The XML node that will be searched
	 * @param name The name of the node that has to be found
	 * @param attribute The name of the attribute
	 * @param value The value of the attribute
	 * @param direction (optional) Specifies the firstChild/nextSibling priority of a match finding
	 * @return The XML node with such a name and attribute
	 */
	public static function getByNameAndAttribute(node:XMLNode, name:String, attribute:String, value:String, direction:Boolean):XMLNode {
		
		if (node.nodeName == name && node.attributes[attribute] == value) {
			return node;
		} else {
			var firstChild = (node.firstChild != null) ? getByNameAndAttribute(node.firstChild, name, attribute, value, direction) : null;
			var nextSibling = (node.nextSibling != null) ? getByNameAndAttribute(node.nextSibling, name, attribute, value, direction) : null;
			return (direction) ? (firstChild || nextSibling) : (nextSibling || firstChild);
		}
	}

}