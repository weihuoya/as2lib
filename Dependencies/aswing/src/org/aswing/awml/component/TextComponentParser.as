/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.ComponentParser;
import org.aswing.JTextComponent;

/**
 * Parses {@link org.aswing.JTextComponent} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.TextComponentParser extends ComponentParser {
	
	private static var ATTR_EDITABLE:String = "editable";
	private static var ATTR_HTML:String = "html";
	private static var ATTR_TEXT:String = "text";
	private static var ATTR_MAX_CHARS:String = "max-chars";
	private static var ATTR_PASSWORD:String = "password";
	private static var ATTR_RESTRICT:String = "restrict";
	
	/**
	 * Private Constructor.
	 */
	private function TextComponentParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, text:JTextComponent):JTextComponent {
		super.parse(awml, text);
		
		// TODO add text format support
		
		// init editable
		text.setEditable(getAttributeAsBoolean(awml, ATTR_EDITABLE, text.isEditable()));
		
		// init html
		text.setHtml(getAttributeAsBoolean(awml, ATTR_HTML, text.isHtml()));
		
		// init text
		text.setText(getAttributeAsString(awml, ATTR_TEXT, text.getText()));	
		
		// init max chars
		text.setMaxChars(getAttributeAsNumber(awml, ATTR_MAX_CHARS, text.getMaxChars()));
		
		// init password
		text.setPasswordField(getAttributeAsBoolean(awml, ATTR_PASSWORD, text.isPasswordField()));
		
		// init restrict
		text.setRestrict(getAttributeAsString(awml, ATTR_RESTRICT, text.getRestrict()));
		
		return text;
	}
	
}
