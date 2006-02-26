/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.TextComponentParser;
import org.aswing.JTextField;

/**
 * Parses {@link org.aswing.JTextField} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.TextFieldParser extends TextComponentParser {
	
	private static var ATTR_COLUMNS:String = "columns";
	
	/**
	 * Constructor.
	 */
	public function TextFieldParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, text:JTextField):JTextField {
		
		// check if undefined
		if (text == null) {
			text = new JTextField();	
		}
		
		super.parse(awml, text);
		
		// init columns
		text.setColumns(getAttributeAsNumber(awml, ATTR_COLUMNS, text.getColumns()));
		
		return text;
	}
	
}
