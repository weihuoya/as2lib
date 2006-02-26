/*
 Copyright aswing.org, see the LICENCE.txt.
*/

/**
 * Provides utility routines for AWML parser.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.AwmlUtils {
	
	/**
	 * Extracts pure node name from the passed XML element omitting namespace prefix.
	 * 
	 * @param xml the <code>XMLNode</code> to extract node name from
	 * @return extracted node name
	 */
	public static function getNodeName(xml:XMLNode):String {
		var idx:Number = xml.nodeName.indexOf(":");
		return (idx == -1) ? xml.nodeName : xml.nodeName.substr(idx + 1);
	}
	
	
}