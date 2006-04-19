/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.AttachIcon;
import org.aswing.awml.AbstractParser;
import org.aswing.Icon;

/**
 *  Parses {@link org.aswing.AttachIcon} element.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.icon.AttachIconParser extends AbstractParser {
	
	private static var ATTR_LINKAGE:String = "linkage";
	private static var ATTR_WIDTH:String = "width";
	private static var ATTR_HEIGHT:String = "height";
	private static var ATTR_SCALE:String = "scale";
	
	/**
	 * Constructor.
	 */
	public function AttachIconParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode):Icon {
		
		
		// init properties
		var linkage:String = getAttributeAsString(awml, ATTR_LINKAGE, null);
		var width:Number = getAttributeAsNumber(awml, ATTR_WIDTH, null);
		var height:Number = getAttributeAsNumber(awml, ATTR_HEIGHT, null);
		var scale:Boolean = getAttributeAsBoolean(awml, ATTR_SCALE, null);
	
		// create icon
		var icon:Icon = new AttachIcon(linkage, width, height, scale);
	
		// process super
		super.parse(awml, icon);
	
		return icon;
	}

}