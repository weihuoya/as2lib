/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.ComponentParser;
import org.aswing.JScrollBar;

/**
 * Parses {@link org.aswing.JScrollBar} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.ScrollBarParser extends ComponentParser {
	
	private static var ATTR_ORIENTATION:String = "orientation";
	private static var ATTR_BLOCK_INCREMENT:String = "block-increment";
	private static var ATTR_UNIT_INCREMENT:String = "unit-increment";
	private static var ATTR_MINIMUM:String = "minimum";
	private static var ATTR_MAXIMUM:String = "maximum";
	private static var ATTR_EXTENT:String = "extent";
	private static var ATTR_VALUE:String = "value";
	
	private static var ORIENTATION_HORIZONTAL:String = "horizontal";
	private static var ORIENTATION_VERTICAL:String = "vertical"; 
	
	/**
	 * Constructor.
	 */
	public function ScrollBarParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, bar:JScrollBar):JScrollBar {
		if (bar == null) {
			bar = new JScrollBar();	
		}
		
		super.parse(awml, bar);
		
		// init increments
		bar.setBlockIncrement(getAttributeAsNumber(awml, ATTR_BLOCK_INCREMENT, bar.getBlockIncrement()));
		bar.setUnitIncrement(getAttributeAsNumber(awml, ATTR_UNIT_INCREMENT, bar.getUnitIncrement()));
		
		// init scroll bounds
		bar.setMinimum(getAttributeAsNumber(awml, ATTR_MINIMUM, bar.getMinimum()));
		bar.setMaximum(getAttributeAsNumber(awml, ATTR_MAXIMUM, bar.getMaximum()));
		bar.setVisibleAmount(getAttributeAsNumber(awml, ATTR_EXTENT, bar.getVisibleAmount()));
		bar.setValue(getAttributeAsNumber(awml, ATTR_VALUE, bar.getValue()));
		
		// set orientation
		var orientation:String = getAttributeAsString(awml, ATTR_ORIENTATION, null);
		switch (orientation) {
			case ORIENTATION_HORIZONTAL:
				bar.setOrientation(JScrollBar.HORIZONTAL);
				break;
			case ORIENTATION_VERTICAL:
				bar.setOrientation(JScrollBar.VERTICAL);
				break;
		}
		
		return bar;
	}

}
