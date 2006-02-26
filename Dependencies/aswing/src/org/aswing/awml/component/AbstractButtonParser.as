/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.ComponentParser;
import org.aswing.JTextComponent;
import org.aswing.JSeparator;
import org.aswing.AbstractButton;
import org.aswing.awml.AwmlConstants;
import org.aswing.Insets;
import org.aswing.awml.AwmlParser;

/**
 * Parses {@link org.aswing.AbstractButton} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.AbstractButtonParser extends ComponentParser {
    
    private static var ATTR_HORIZONTAL_ALIGN:String = "horizontal-align";
    private static var ATTR_VERTICAL_ALIGN:String = "vertical-align";
    private static var ATTR_HORIZONTAL_POSITION:String = "horizontal-position";
    private static var ATTR_VERTICAL_POSITION:String = "vertical-position";
    private static var ATTR_TEXT:String = "text";
    private static var ATTR_ICON_TEXT_GAP:String = "icon-text-gap";
    private static var ATTR_ROLL_OVER_ENABLED:String = "roll-over-enabled";
    
    private static var ALIGN_TOP:String = "top";
    private static var ALIGN_CENTER:String = "center";
    private static var ALIGN_BOTTOM:String = "bottom";
    private static var ALIGN_LEFT:String = "left";
    private static var ALIGN_RIGHT:String = "right";
    
    /**
     * Private Constructor.
     */
    private function AbstractButtonParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, button:AbstractButton):AbstractButton {
    	
        super.parse(awml, button);
        
        // TODO icon support
        
        // init aligns
        var halign:String = getAttributeAsString(awml, ATTR_HORIZONTAL_ALIGN);
        switch (halign) {
        	case ALIGN_LEFT:
        		button.setHorizontalAlignment(AbstractButton.LEFT);
        		break;
        	case ALIGN_CENTER:
        		button.setHorizontalAlignment(AbstractButton.CENTER);
        		break;	
        	case ALIGN_RIGHT:
        		button.setHorizontalAlignment(AbstractButton.RIGHT);
        		break;	
        }

        var valign:String = getAttributeAsString(awml, ATTR_VERTICAL_ALIGN);
        switch (valign) {
        	case ALIGN_TOP:
        		button.setVerticalAlignment(AbstractButton.TOP);
        		break;
        	case ALIGN_CENTER:
        		button.setVerticalAlignment(AbstractButton.CENTER);
        		break;	
        	case ALIGN_BOTTOM:
        		button.setVerticalAlignment(AbstractButton.BOTTOM);
        		break;	
        }
        
        // init text positions
        var hpos:String = getAttributeAsString(awml, ATTR_HORIZONTAL_POSITION);
        switch (hpos) {
        	case ALIGN_LEFT:
        		button.setHorizontalTextPosition(AbstractButton.LEFT);
        		break;
        	case ALIGN_CENTER:
        		button.setHorizontalTextPosition(AbstractButton.CENTER);
        		break;	
        	case ALIGN_RIGHT:
        		button.setHorizontalTextPosition(AbstractButton.RIGHT);
        		break;	
        }
        
        var vpos:String = getAttributeAsString(awml, ATTR_VERTICAL_POSITION);
        switch (vpos) {
        	case ALIGN_TOP:
        		button.setVerticalTextPosition(AbstractButton.TOP);
        		break;
        	case ALIGN_CENTER:
        		button.setVerticalTextPosition(AbstractButton.CENTER);
        		break;	
        	case ALIGN_BOTTOM:
        		button.setVerticalTextPosition(AbstractButton.BOTTOM);
        		break;	
        }
        
        // init text
        button.setText(getAttributeAsString(awml, ATTR_TEXT, button.getText()));
        
        // init icon text gap
        button.setIconTextGap(getAttributeAsNumber(awml, ATTR_ICON_TEXT_GAP, button.getIconTextGap()));
        
        // set roll over enabled
        button.setRollOverEnabled(getAttributeAsBoolean(awml, ATTR_ROLL_OVER_ENABLED, button.isRollOverEnabled()));
        
        return button;
	}
    
    private function parseChild(awml:XMLNode, nodeName:String, button:AbstractButton):Void {
    	super.parseChild(awml, nodeName, button);
    	
    	// init insets
    	if (nodeName == AwmlConstants.NODE_MARGINS) {
    		var insets:Insets = AwmlParser.parse(awml);
    		if (insets != null) button.setMargin(insets);	
    	}
    }
    
}
