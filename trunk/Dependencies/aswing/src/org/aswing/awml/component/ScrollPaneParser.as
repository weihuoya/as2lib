/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AwmlParser;
import org.aswing.awml.AwmlUtils;
import org.aswing.awml.component.ComponentParser;
import org.aswing.Component;
import org.aswing.JScrollPane;
import org.aswing.awml.AwmlConstants;
import org.aswing.JScrollBar;

/**
 * Parses {@link org.aswing.JScrollPane} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.ScrollPaneParser extends ComponentParser {
	
	private static var ATTR_HORIZONTAL_SCROLL_BAR_POLICY:String = "horizontal-scroll-bar-policy";
	private static var ATTR_VERTICAL_SCROLL_BAR_POLICY:String = "vertical-scroll-bar-policy";
	
	private static var POLICY_NEVER:String = "never";
	private static var POLICY_AS_NEEDED:String = "as-needed";
	private static var POLICY_ALWAYS:String = "always";
	
	/**
	 * Constructor.
	 */
	public function ScrollPaneParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, view:JScrollPane):JScrollPane {
		if (view == null) {
			view = new JScrollPane();	
		}
		
		super.parse(awml, view);
		
		// init scroll bar policies
		var hPolicy:String = getAttributeAsString(awml, ATTR_HORIZONTAL_SCROLL_BAR_POLICY);
		switch (hPolicy) {
			case POLICY_NEVER:
				view.setHorizontalScrollBarPolicy(JScrollPane.SCROLLBAR_NEVER);
				break;
			case POLICY_AS_NEEDED:
				view.setHorizontalScrollBarPolicy(JScrollPane.SCROLLBAR_AS_NEEDED);
				break;
			case POLICY_ALWAYS:
				view.setHorizontalScrollBarPolicy(JScrollPane.SCROLLBAR_ALWAYS);
				break;
		}
				
		var vPolicy:String = getAttributeAsString(awml, ATTR_VERTICAL_SCROLL_BAR_POLICY);
		switch (vPolicy) {
			case POLICY_NEVER:
				view.setVerticalScrollBarPolicy(JScrollPane.SCROLLBAR_NEVER);
				break;
			case POLICY_AS_NEEDED:
				view.setVerticalScrollBarPolicy(JScrollPane.SCROLLBAR_AS_NEEDED);
				break;
			case POLICY_ALWAYS:
				view.setVerticalScrollBarPolicy(JScrollPane.SCROLLBAR_ALWAYS);
				break;
		}
		
		return view;
	}

	private function parseChild(awml:XMLNode, nodeName:String, view:JScrollPane):Void {

		super.parseChild(awml, nodeName, view);

		if (AwmlUtils.isComponentNode(nodeName)) {
			var component:Component = AwmlParser.parse(awml);
			if (component != null) view.setView(component);	
		} else if (nodeName == AwmlConstants.NODE_HORIZONTAL_SCROLL_BAR) {
			var bar:JScrollBar = AwmlParser.parse(awml);
			if (bar != null) view.setHorizontalScrollBar(bar);	
		} else if (nodeName == AwmlConstants.NODE_VERTICAL_SCROLL_BAR) {
			var bar:JScrollBar = AwmlParser.parse(awml);
			if (bar != null) view.setVerticalScrollBar(bar);	
		}
	}

}
