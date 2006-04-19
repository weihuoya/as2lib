/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.ContainerParser;
import org.aswing.FloorPane;

/**
 * Parses {@link org.aswing.FloorPane} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.FloorPaneParser extends ContainerParser {
    
    private static var ATTR_HORIZONTAL_ALIGN:String = "horizontal-align";
    private static var ATTR_VERTICAL_ALIGN:String = "vertical-align";
    private static var ATTR_OFFSET_X:String = "offset-x";
    private static var ATTR_OFFSET_Y:String = "offset-y";
    private static var ATTR_MASK_FLOOR:String = "mask-floor";
    private static var ATTR_SCALE_IMAGE:String = "scale-image";
    private static var ATTR_PREFERRED_SIZE_STRATEGY:String = "preferred-size-strategy";
    
    private static var ALIGN_TOP:String = "top";
    private static var ALIGN_BOTTOM:String = "bottom";
    private static var ALIGN_CENTER:String = "center";
    private static var ALIGN_LEFT:String = "left";
    private static var ALIGN_RIGHT:String = "right";
    
    private static var STRATEGY_BOTH:String = "both";
    private static var STRATEGY_IMAGE:String = "image";
    private static var STRATEGY_LAYOUT:String = "layout";
    
    /**
     * Private Constructor.
     */
    private function FloorPaneParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, pane:FloorPane):FloorPane {
    	
        super.parse(awml, pane);
        
        // init offsets
        pane.setOffsetX(getAttributeAsNumber(awml, ATTR_OFFSET_X, pane.getOffsetX()));
        pane.setOffsetY(getAttributeAsNumber(awml, ATTR_OFFSET_Y, pane.getOffsetY()));
        
        // init mask floor
        pane.setMaskFloor(getAttributeAsBoolean(awml, ATTR_MASK_FLOOR, pane.isMaskFloor()));
        
        // init scale image
        pane.setScaleImage(getAttributeAsBoolean(awml, ATTR_SCALE_IMAGE, pane.isScaleImage()));    
        
        // init aligns
        var hAlign:String = getAttributeAsString(awml, ATTR_HORIZONTAL_ALIGN);
        switch (hAlign) {
        	case ALIGN_LEFT:
        		pane.setHorizontalAlignment(FloorPane.LEFT);
        		break;	
        	case ALIGN_CENTER:
        		pane.setHorizontalAlignment(FloorPane.CENTER);
        		break;	
        	case ALIGN_RIGHT:
        		pane.setHorizontalAlignment(FloorPane.RIGHT);
        		break;	
        }

        var vAlign:String = getAttributeAsString(awml, ATTR_VERTICAL_ALIGN);
        switch (vAlign) {
        	case ALIGN_TOP:
        		pane.setHorizontalAlignment(FloorPane.TOP);
        		break;	
        	case ALIGN_CENTER:
        		pane.setHorizontalAlignment(FloorPane.CENTER);
        		break;	
        	case ALIGN_BOTTOM:
        		pane.setHorizontalAlignment(FloorPane.BOTTOM);
        		break;	
        }

        // init preferred size strategy
        var strategy:String = getAttributeAsString(awml, ATTR_PREFERRED_SIZE_STRATEGY);
        switch (strategy) {
        	case STRATEGY_BOTH:
        		pane.setPrefferSizeStrategy(FloorPane.PREFER_SIZE_BOTH);
        		break;	
        	case STRATEGY_IMAGE:
        		pane.setPrefferSizeStrategy(FloorPane.PREFER_SIZE_IMAGE);
        		break;	
        	case STRATEGY_LAYOUT:
        		pane.setPrefferSizeStrategy(FloorPane.PREFER_SIZE_LAYOUT);
        		break;	
        }
        
        return pane;
    }
        
}
