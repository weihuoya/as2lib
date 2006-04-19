/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.AbstractTabbedPane;
import org.aswing.awml.AbstractParser;
import org.aswing.awml.AwmlParser;
import org.aswing.awml.AwmlUtils;
import org.aswing.Component;
import org.aswing.Icon;

/**
 *  Parses tabs for {@link org.aswing.JAccordionJTabbedPane} and
 *  {@link org.aswing.JAccordion}.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.tab.TabParser extends AbstractParser {
	
	private static var ATTR_TITLE:String = "title";
	private static var ATTR_TOOL_TIP:String = "tool-tip";
	
	
	/**
	 * Constructor.
	 */
	public function TabParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, tabPane:AbstractTabbedPane):AbstractTabbedPane {
		
		// init title
		var title:String = getAttributeAsString(awml, ATTR_TITLE, "");
		
		// init tool tip
		var tip:String = getAttributeAsString(awml, ATTR_TOOL_TIP, null);
	
		var icon:Icon;
		var component:Component;
	
		// get component and icon to add
		for (var i = 0; i < awml.childNodes.length; i++) {
			
			var nodeName:String = AwmlUtils.getNodeName(awml.childNodes[i]); 
			
			// check if child node belongs to component		
			if (component == null && AwmlUtils.isComponentNode(nodeName)) {
				component = Component(AwmlParser.parse(awml.childNodes[i]));
			}
			
			// check if this is icon
			if (icon == null && AwmlUtils.isIconNode(nodeName)) {
	    		icon = Icon(AwmlParser.parse(awml.childNodes[i]));
	    	}
		}
	
		// add tab to the tabbed pane
		tabPane.appendTab(component, title, icon, tip);

		return tabPane;
	}

}