/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AbstractParser;
import org.aswing.awml.AwmlConstants;
import org.aswing.awml.AwmlUtils;
import org.aswing.awml.ParserFactory;

/**
 * Provides AWML parsing routines. Manages parsing process by calling proper parsers for appropriate
 * components, layouts, borders and etc. described in AWML document.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.AwmlParser {
	
	/**
	 * Private constructor.
	 */
	private function AwmlParser(Void) {
		//
	}
		
	/**
	 * parse(awml:XMLNode, instance)<br>
	 * parse(awml:String, instance)<br>
	 * parse(awml:XMLNode)<br>
	 * parse(awml:String)<br>
	 * 
	 * Parses passed <code>awml</code> document and initializes <code>instance</code> with appropriate
	 * properties and sub-elements. If no <code>instance</code> is specified new object is
	 * created with type based on top element from the <code>awml</code> document.
	 * 
	 * @param awml the AWML document to parse. Can be both <code>Strig</code> and <code>XMLNode</code>.
	 * @param instance the object to initialize with AWML data.
	 * @return instance initialized with AWML data. 
	 */
	public static function parse(awml, instance) {
		var xml:XMLNode = (awml instanceof XMLNode) ? awml : stringToXml(awml);
		if (AwmlUtils.getNodeName(xml) == AwmlConstants.NODE_ASWING) {
			xml = xml.firstChild;	
		}
		var parserName:String = AwmlUtils.getNodeName(xml);
		var parser:AbstractParser = ParserFactory.getInstance().get(parserName);
		instance = parser.parse(xml, instance);
		return instance;	
	}
	
	/**
	 * Converts string represenration of the XML document to the XMLNode object.
	 * 
	 * @param str the string representation of the XML document to convert.
	 * @return XMLNode representation of the XML document.
	 */
	private static function stringToXml(str:String):XMLNode {
        var xml:XML = new XML();
        xml.ignoreWhite = true;
        xml.parseXML(str);
        return xml.firstChild; 
	}
	
}
