/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.AbstractTabbedPane;
import org.aswing.awml.AbstractParser;
import org.aswing.awml.AwmlParser;
import org.aswing.awml.AwmlUtils;
import org.aswing.Component;
import TextField.StyleSheet;

/**
 *  Parses css for {@link org.aswing.JTextComponent}.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.text.CSSParser extends AbstractParser {
	
	/**
	 * Constructor.
	 */
	public function CSSParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode):StyleSheet {
		
		super.parse(awml);
		
		// init css text
		var cssText:String = "";
		for (var i = 0; i < awml.childNodes.length; i++) {
			cssText += getValueAsString(awml.childNodes[i], "");	
		}
		
		// create style object
		var css:StyleSheet = new StyleSheet();
		css.parseCSS(cssText);
		
		return css;
	}

}