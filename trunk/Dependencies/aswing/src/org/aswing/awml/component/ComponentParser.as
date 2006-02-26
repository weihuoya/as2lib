/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AbstractParser;
import org.aswing.Component;
import org.aswing.BorderLayout;

/**
 * Parses {@link org.aswing.Component} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.ComponentParser extends AbstractParser {
	
	private static var ATTR_ENABLED:String = "enabled";
	private static var ATTR_VISIBLE:String = "visible";
	private static var ATTR_FOCUS:String = "focus";
	private static var ATTR_X:String = "x";
	private static var ATTR_Y:String = "y";
	private static var ATTR_MIN_WIDTH:String = "min-width";
	private static var ATTR_MIN_HEIGHT:String = "min-height";
	private static var ATTR_MAX_WIDTH:String = "max-width";
	private static var ATTR_MAX_HEIGHT:String = "max-height";
	private static var ATTR_WIDTH:String = "width";
	private static var ATTR_HEIGHT:String = "height";
	private static var ATTR_PREFERRED_WIDTH:String = "preferred-width";
	private static var ATTR_PREFERRED_HEIGHT:String = "preferred-height";
	private static var ATTR_OPAQUE:String = "opaque";
	private static var ATTR_TOOL_TIP:String = "tool-tip";
	private static var ATTR_HAND_CURSOR:String = "hand-cursor";
	private static var ATTR_CONSTRAINT:String = "constraint";
	private static var ATTR_TRIGGER_ENABLED:String = "trigger-enabled";
	
	private static var CONSTRAINT_NORTH:String = "north";
	private static var CONSTRAINT_SOUTH:String = "south";
	private static var CONSTRAINT_WEST:String = "west";
	private static var CONSTRAINT_EAST:String = "east";
	private static var CONSTRAINT_CENTER:String = "center"; 
	
	/**
	 * Private Constructor.
	 */
	private function ComponentParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, component:Component):Component {
		
		super.parse(awml, component);
		
		// TODO id support
		// TODO background
		// TODO foreground 
		// TODO font
		// TODO border
		
		// set enabled
		component.setEnabled(getAttributeAsBoolean(awml, ATTR_ENABLED, component.isEnabled()));
		
		// set visible
		component.setVisible(getAttributeAsBoolean(awml, ATTR_VISIBLE, component.isVisible()));
		
		// set focus
		if (getAttributeAsBoolean(awml, ATTR_FOCUS, false)) {
			component.requestFocus();
		}
		
		// set location
		var x:Number = getAttributeAsNumber(awml, ATTR_X, component.getLocation().x);
		var y:Number = getAttributeAsNumber(awml, ATTR_Y, component.getLocation().y);
		component.setLocation(x,y);
		
		// set min size
		var minWidth:Number = getAttributeAsNumber(awml, ATTR_MIN_WIDTH, 
				component.getMinimumSize().width);
		var minHeight:Number = getAttributeAsNumber(awml, ATTR_MIN_HEIGHT, 
				component.getMinimumSize().height);
		component.setMinimumSize(minWidth, minHeight);
		
		// set max size
		var maxWidth:Number = getAttributeAsNumber(awml, ATTR_MAX_WIDTH, 
				component.getMaximumSize().width);
		var maxHeight:Number = getAttributeAsNumber(awml, ATTR_MAX_HEIGHT, 
				component.getMaximumSize().height);
		component.setMaximumSize(maxWidth, maxHeight);

		// set size
		var width:Number = getAttributeAsNumber(awml, ATTR_WIDTH, component.getWidth());
		var height:Number = getAttributeAsNumber(awml, ATTR_HEIGHT, component.getHeight());
		component.setSize(width, height);

		// set size
		var prefWidth:Number = getAttributeAsNumber(awml, ATTR_PREFERRED_WIDTH, null); 
		var prefHeight:Number = getAttributeAsNumber(awml, ATTR_PREFERRED_HEIGHT, null);
		
		if (prefWidth != null || prefHeight != null) {
			if (prefWidth == null) {
				prefWidth = component.getPreferredSize().width;
			} 
			if (prefHeight == null) {
				prefHeight = component.getPreferredSize().height;
			} 
			component.setPreferredSize(prefWidth, prefHeight);
		}
		
		// set opaque
		component.setOpaque(getAttributeAsBoolean(awml, ATTR_OPAQUE, component.isOpaque()));
		
		// set tool tip
		component.setToolTipText(getAttributeAsString(awml, ATTR_TOOL_TIP));
		
		// use hand cursor
		component.setUseHandCursor(getAttributeAsBoolean(awml, ATTR_HAND_CURSOR, component.isUseHandCursor()));
		
		// init trigger enabled
		component.setTriggerEnabled(getAttributeAsBoolean(awml, ATTR_TRIGGER_ENABLED, component.isTriggerEnabled()));
		
		// update constraints
		var constraint:String = getAttributeAsString(awml, ATTR_CONSTRAINT);
		switch (constraint) {
			case CONSTRAINT_NORTH:
				component.setConstraints(BorderLayout.NORTH);
				break;
			case CONSTRAINT_SOUTH:
				component.setConstraints(BorderLayout.SOUTH);
				break;
			case CONSTRAINT_WEST:
				component.setConstraints(BorderLayout.WEST);
				break;
			case CONSTRAINT_EAST:
				component.setConstraints(BorderLayout.EAST);
				break;
			case CONSTRAINT_CENTER:
				component.setConstraints(BorderLayout.CENTER);
				break;
		}
		
		return component;
	}
	
}
