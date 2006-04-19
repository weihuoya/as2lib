/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.FloorPaneParser;
import org.aswing.JLoadPane;

/**
 * Parses {@link org.aswing.JLoadPane} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.LoadPaneParser extends FloorPaneParser {
	
	private static var ATTR_URL:String = "url";
	
	/**
	 * Constructor.
	 */
	public function LoadPaneParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, pane:JLoadPane):JLoadPane {
		
		// check if undefined
		if (pane == null) {
			pane = new JLoadPane();	
		}
		
		super.parse(awml, pane);
		
		// init columns
		pane.setPath(getAttributeAsString(awml, ATTR_URL, pane.getPath()));
		
		return pane;
	}
	
}
