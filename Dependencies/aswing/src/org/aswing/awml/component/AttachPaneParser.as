/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.FloorPaneParser;
import org.aswing.JAttachPane;

/**
 * Parses {@link org.aswing.JAttachPane} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.AttachPaneParser extends FloorPaneParser {
	
	private static var ATTR_SYMBOL_ID:String = "symbol-id";
	
	/**
	 * Constructor.
	 */
	public function AttachPaneParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, pane:JAttachPane):JAttachPane {
		
		// check if undefined
		if (pane == null) {
			pane = new JAttachPane();	
		}
		
		super.parse(awml, pane);
		
		// init columns
		pane.setPath(getAttributeAsString(awml, ATTR_SYMBOL_ID, pane.getPath()));
		
		return pane;
	}
	
}
