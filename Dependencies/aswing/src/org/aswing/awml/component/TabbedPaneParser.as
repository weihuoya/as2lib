/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.AbstractTabbedPaneParser;
import org.aswing.JTabbedPane;

/**
 * Parses {@link org.aswing.JTabbedPane} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.TabbedPaneParser extends AbstractTabbedPaneParser {
    
	private static var ATTR_TAB_PLACEMENT:String = "tab-placement";
	
	private static var TAB_PLACEMENT_TOP:String = "top";
	private static var TAB_PLACEMENT_LEFT:String = "left";
	private static var TAB_PLACEMENT_RIGHT:String = "right";
	private static var TAB_PLACEMENT_BOTTOM:String = "bottom";
    
    
    /**
     * Constructor.
     */
    public function TabbedPaneParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, tabPane:JTabbedPane):JTabbedPane {
    	
    	if (tabPane == null) {
    		tabPane = new JTabbedPane();	
    	} 
    	
        super.parse(awml, tabPane);
        
        // init tab placement
        var placement:String = getAttributeAsString(awml, ATTR_TAB_PLACEMENT);
        switch (placement) {
        	case TAB_PLACEMENT_TOP:
        		tabPane.setTabPlacement(JTabbedPane.TOP);
        		break;
        	case TAB_PLACEMENT_LEFT:
        		tabPane.setTabPlacement(JTabbedPane.LEFT);
        		break;
        	case TAB_PLACEMENT_RIGHT:
        		tabPane.setTabPlacement(JTabbedPane.RIGHT);
        		break;
        	case TAB_PLACEMENT_BOTTOM:
        		tabPane.setTabPlacement(JTabbedPane.BOTTOM);
        		break;
        }
        
        return tabPane;
	}
    
}
