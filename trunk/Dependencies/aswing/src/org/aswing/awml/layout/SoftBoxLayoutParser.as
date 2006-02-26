/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.layout.EmptyLayoutParser;
import org.aswing.SoftBoxLayout;

/**
 * Parses {@link org.aswing.SoftBoxLayout} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.layout.SoftBoxLayoutParser extends EmptyLayoutParser {
	
	private static var ATTR_AXIS:String = "axis";
	private static var ATTR_GAP:String = "gap";
	
	private static var AXIS_X:String = "x";
	private static var AXIS_Y:String = "y";
	
	/**
     * Constructor.
     */
	public function SoftBoxLayoutParser(Void) {
		super();
	}

	public function parse(awml:XMLNode, layout:SoftBoxLayout):SoftBoxLayout {
		
		if (layout == null) {
			layout = new SoftBoxLayout();	
		}
		
		super.parse(awml, layout);
		
		// init layout
		var axis:String = getAttributeAsString(awml, ATTR_AXIS);
		switch (axis) {
			case AXIS_Y:
				layout.setAxis(SoftBoxLayout.Y_AXIS);
				break;
			case AXIS_X:
				layout.setAxis(SoftBoxLayout.X_AXIS);
				break;	
		}
		
		// init gap
		layout.setGap(getAttributeAsNumber(awml, ATTR_GAP, layout.getGap()));
		
		return layout;
	}	
}