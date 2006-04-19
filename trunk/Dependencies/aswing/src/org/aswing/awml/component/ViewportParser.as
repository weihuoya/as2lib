/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AwmlParser;
import org.aswing.awml.AwmlUtils;
import org.aswing.awml.component.ComponentParser;
import org.aswing.Component;
import org.aswing.geom.Point;
import org.aswing.JViewport;

/**
 * Parses {@link org.aswing.JViewport} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.ViewportParser extends ComponentParser {
	
	private static var ATTR_HORIZONTAL_BLOCK_INCREMENT:String = "horizontal-block-increment";
	private static var ATTR_VERTICAL_BLOCK_INCREMENT:String = "vertical-block-increment";
	private static var ATTR_HORIZONTAL_UNIT_INCREMENT:String = "horizontal-unit-increment";
	private static var ATTR_VERTICAL_UNIT_INCREMENT:String = "vertical-unit-increment";
	private static var ATTR_VIEW_POSITION_X:String = "view-position-x";
	private static var ATTR_VIEW_POSITION_Y:String = "view-position-y";
	
	/**
	 * Constructor.
	 */
	public function ViewportParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, view:JViewport):JViewport {
		if (view == null) {
			view = new JViewport();	
		}
		
		super.parse(awml, view);
		
		// init block increments
		view.setHorizontalBlockIncrement(getAttributeAsNumber(awml, ATTR_HORIZONTAL_BLOCK_INCREMENT, view.getHorizontalBlockIncrement()));
		view.setVerticalBlockIncrement(getAttributeAsNumber(awml, ATTR_VERTICAL_BLOCK_INCREMENT, view.getVerticalBlockIncrement()));
		view.setHorizontalUnitIncrement(getAttributeAsNumber(awml, ATTR_HORIZONTAL_UNIT_INCREMENT, view.getHorizontalUnitIncrement()));
		view.setVerticalUnitIncrement(getAttributeAsNumber(awml, ATTR_VERTICAL_UNIT_INCREMENT, view.getVerticalUnitIncrement()));
		
		// init view position
		var x:Number = getAttributeAsNumber(awml, ATTR_VIEW_POSITION_X, view.getViewPosition().x);
		var y:Number = getAttributeAsNumber(awml, ATTR_VIEW_POSITION_Y, view.getViewPosition().y);
		view.setViewPosition(new Point(x,y));
		
		return view;
	}

	private function parseChild(awml:XMLNode, nodeName:String, view:JViewport):Void {

		super.parseChild(awml, nodeName, view);

		if (AwmlUtils.isComponentNode(nodeName)) {
			var component:Component = AwmlParser.parse(awml);
			if (component != null) view.setView(component);	
		}
	}

}
