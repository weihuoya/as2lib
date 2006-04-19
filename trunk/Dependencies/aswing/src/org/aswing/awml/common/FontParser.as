/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AbstractParser;
import org.aswing.EmptyLayout;
import org.aswing.Insets;
import org.aswing.ASFont;

/**
 *  Parses {@link org.aswing.ASFont} element.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.common.FontParser extends AbstractParser {
	
	private static var ATTR_NAME:String = "name";
	private static var ATTR_SIZE:String = "size";
	private static var ATTR_BOLD:String = "bold";
	private static var ATTR_ITALIC:String = "italic"; 
	private static var ATTR_UNDERLINE:String = "underline";
	private static var ATTR_EMBEDED:String = "embeded";
	
	/**
	 * Constructor.
	 */
	public function FontParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode):ASFont {
		
		// init properties
		var name:String = getAttributeAsString(awml, ATTR_NAME, null);
		var size:Number = getAttributeAsNumber(awml, ATTR_SIZE, null);
		var bold:Boolean = getAttributeAsBoolean(awml, ATTR_BOLD, null);
		var italic:Boolean = getAttributeAsBoolean(awml, ATTR_ITALIC, null);
		var underline:Boolean = getAttributeAsBoolean(awml, ATTR_UNDERLINE, null);
		var embeded:Boolean = getAttributeAsBoolean(awml, ATTR_EMBEDED, null);
		
		// create font object
		var font:ASFont = new ASFont(name, size, bold, italic, underline, embeded);	
	
		// process parent
		super.parse(awml, font);
	
		return font;
	}

}