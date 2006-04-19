/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.AbstractTabbedPane;
import org.aswing.awml.AwmlConstants;
import org.aswing.awml.AwmlParser;
import org.aswing.awml.component.ComponentParser;
import org.aswing.Insets;

/**
 * Parses {@link org.aswing.AbstractTabbedPane} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.AbstractTabbedPaneParser extends ComponentParser {
    
    private static var ATTR_HORIZONTAL_ALIGN:String = "horizontal-align";
    private static var ATTR_VERTICAL_ALIGN:String = "vertical-align";
    private static var ATTR_HORIZONTAL_TEXT_POSITION:String = "horizontal-text-position";
    private static var ATTR_VERTICAL_TEXT_POSITION:String = "vertical-text-position";
    private static var ATTR_ICON_TEXT_GAP:String = "icon-text-gap";
    private static var ATTR_SELECTED_INDEX:String = "selected-index";
    
    private static var ALIGN_TOP:String = "top";
    private static var ALIGN_CENTER:String = "center";
    private static var ALIGN_BOTTOM:String = "bottom";
    private static var ALIGN_LEFT:String = "left";
    private static var ALIGN_RIGHT:String = "right";
    
    private static var POSITION_TOP:String = "top";
    private static var POSITION_CENTER:String = "center";
    private static var POSITION_BOTTOM:String = "bottom";
    private static var POSITION_LEFT:String = "left";
    private static var POSITION_RIGHT:String = "right";
    
    /**
     * Private Constructor.
     */
    private function AbstractTabbedPaneParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, tabPane:AbstractTabbedPane):AbstractTabbedPane {
    	
        super.parse(awml, tabPane);
        
        // init aligns
        var halign:String = getAttributeAsString(awml, ATTR_HORIZONTAL_ALIGN);
        switch (halign) {
        	case ALIGN_LEFT:
        		tabPane.setHorizontalAlignment(AbstractTabbedPane.LEFT);
        		break;
        	case ALIGN_CENTER:
        		tabPane.setHorizontalAlignment(AbstractTabbedPane.CENTER);
        		break;	
        	case ALIGN_RIGHT:
        		tabPane.setHorizontalAlignment(AbstractTabbedPane.RIGHT);
        		break;	
        }

        var valign:String = getAttributeAsString(awml, ATTR_VERTICAL_ALIGN);
        switch (valign) {
        	case ALIGN_TOP:
        		tabPane.setVerticalAlignment(AbstractTabbedPane.TOP);
        		break;
        	case ALIGN_CENTER:
        		tabPane.setVerticalAlignment(AbstractTabbedPane.CENTER);
        		break;	
        	case ALIGN_BOTTOM:
        		tabPane.setVerticalAlignment(AbstractTabbedPane.BOTTOM);
        		break;	
        }
        
        // init text positions
        var hpos:String = getAttributeAsString(awml, ATTR_HORIZONTAL_TEXT_POSITION);
        switch (hpos) {
        	case POSITION_LEFT:
        		tabPane.setHorizontalTextPosition(AbstractTabbedPane.LEFT);
        		break;
        	case POSITION_CENTER:
        		tabPane.setHorizontalTextPosition(AbstractTabbedPane.CENTER);
        		break;	
        	case POSITION_RIGHT:
        		tabPane.setHorizontalTextPosition(AbstractTabbedPane.RIGHT);
        		break;	
        }
        
        var vpos:String = getAttributeAsString(awml, ATTR_VERTICAL_TEXT_POSITION);
        switch (vpos) {
        	case POSITION_TOP:
        		tabPane.setVerticalTextPosition(AbstractTabbedPane.TOP);
        		break;
        	case POSITION_CENTER:
        		tabPane.setVerticalTextPosition(AbstractTabbedPane.CENTER);
        		break;	
        	case POSITION_BOTTOM:
        		tabPane.setVerticalTextPosition(AbstractTabbedPane.BOTTOM);
        		break;	
        }
        
        // init icon text gap
        tabPane.setIconTextGap(getAttributeAsNumber(awml, ATTR_ICON_TEXT_GAP, tabPane.getIconTextGap()));
        
        // init selected index
        tabPane.setSelectedIndex(getAttributeAsNumber(awml, ATTR_SELECTED_INDEX, tabPane.getSelectedIndex()));
        
        return tabPane;
	}
    
    private function parseChild(awml:XMLNode, nodeName:String, tabPane:AbstractTabbedPane):Void {
    	super.parseChild(awml, nodeName, tabPane);
    	
    	// init insets
    	if (nodeName == AwmlConstants.NODE_MARGINS) {
    		var insets:Insets = AwmlParser.parse(awml);
    		if (insets != null) tabPane.setMargin(insets);	
    	} else if (nodeName == AwmlConstants.NODE_TAB) {
    		AwmlParser.parse(awml, tabPane);	
    	}
    }
    
}
