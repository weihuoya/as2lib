/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AbstractParser;
import org.aswing.EmptyLayout;

/**
 *  Parses {@link org.aswing.EmptyLayout} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.layout.EmptyLayoutParser extends AbstractParser {
	
	/**
	 * Constructor.
	 */
	public function EmptyLayoutParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, layout:EmptyLayout):EmptyLayout {
		if (layout == null) {
			layout = new EmptyLayout();	
		}	
	
		super.parse(awml, layout);
	
		return layout;
	}

}