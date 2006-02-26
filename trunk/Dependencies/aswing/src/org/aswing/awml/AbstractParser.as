import org.aswing.awml.AwmlUtils;
/*
 Copyright aswing.org, see the LICENCE.txt.
*/

/**
 * Provides core utility methods for AWML parser.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.AbstractParser {
	
	/**
	 * Private constructor.
	 */
	private function AbstractParser(Void) {
		//
	}
	
	/**
	 * Parses AWML node and its children.
	 * <p>
	 * Abstract method. Need to be overridden.
	 * 
	 * @param awml the AWML node to parse
	 * @param instance the AsWing object instance to initialize with AWML data.
	 * If instance is undefined new instance based on AWML node name
	 * will be created
	 * @return initialized instance
	 */
	public function parse(awml:XMLNode, instance) {
		
		// TODO parse child components
		for (var i = 0; i < awml.childNodes.length; i++) {
			parseChild(awml.childNodes[i], AwmlUtils.getNodeName(awml.childNodes[i]), instance);	
		}
		
		return instance;
	}

	/**
	 * Parses AWML children nodes of the AWML object. 
	 * <p>
	 * Abstract method. Need to be overridden.
	 * 
	 * @param awml the child AWML node
	 * @param nodeName the child AWML node name
	 * @param instance the AsWing object instance to initialize with data
	 * from child AWML elements 
	 */
	private function parseChild(awml:XMLNode, nodeName:String, instance):Void {
		//
	}

	/**
	 * getAttributeAsString(node:XMLNode, attribute:String, defaultValue:String)<br>
	 * getAttributeAsString(node:XMLNode, attribute:String) defaultValue default to empty string<br>
	 * 
	 * Gets string representation of the <code>attribute</code> value from the passed <code>node</code>.
	 * If requested attribute doesn't exists returns <code>defaultValue</code>.
	 * 
	 * @param node the XML node to get the attribute from.
	 * @param attribute the attribute to get.
	 * @param defaultValue the default value to return if specified attribute doestn't exist.
	 * @return string value of the specified attribute for the given XML node.
	 */
	public function getAttributeAsString(node:XMLNode, attribute:String, defaultValue:String):String {
		var value:String = node.attributes[attribute];
		return (value != null) ? value : (defaultValue !== undefined) ? defaultValue : "";
	}
	
	/**
	 * getAttributeAsNumber(node:XMLNode, attribute:String, defaultValue:Number)<br>
	 * getAttributeAsNumber(node:XMLNode, attribute:String) defaultValue default to <code>0</code><br>
	 * 
	 * Gets numeric representation of the <code>attribute</code> value from the passed <code>node</code>.
	 * If requested attribute doesn't exists returns <code>defaultValue</code>.
	 * 
	 * @param node the XML node to get the attribute from.
	 * @param attribute the attribute to get.
	 * @param defaultValue the default value to return if specified attribute doestn't exist.
	 * @return numeric value of the specified attribute for the given XML node.
	 */
	public function getAttributeAsNumber(node:XMLNode, attribute:String, defaultValue:Number):Number {
		var value:Number = Number(node.attributes[attribute]);
		return (value != null && ! isNaN(value)) ? value : (defaultValue !== undefined) ? defaultValue : 0;
	}

	/**
	 * getAttributeAsBoolean(node:XMLNode, attribute:String, defaultValue:Boolean)<br>
	 * getAttributeAsBoolean(node:XMLNode, attribute:String) defaultValue default to <code>false</code><br>
	 * 
	 * Gets boolean representation of the <code>attribute</code> value from the passed <code>node</code>.
	 * If requested attribute doesn't exists returns <code>defaultValue</code>.
	 * 
	 * @param node the XML node to get the attribute from.
	 * @param attribute the attribute to get.
	 * @param defaultValue the default value to return if specified attribute doestn't exist.
	 * @return boolean value of the specified attribute for the given XML node.
	 */
	public function getAttributeAsBoolean(node:XMLNode, attribute:String, defaultValue:Boolean):Boolean {
		var value:String = String(node.attributes[attribute]).toLowerCase();
		return (value == "true") ? true : (value == "false") ? false : (defaultValue !== undefined) ? defaultValue : false;
	}
	
}
