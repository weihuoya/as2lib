/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.PanelParser;
import org.aswing.SoftBox;
import org.aswing.SoftBoxLayout;

/**
 * Parses {@link org.aswing.SoftBox} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.SoftBoxParser extends PanelParser {
    
    private static var ATTR_AXIS:String = "axis";
    private static var ATTR_GAP:String = "gap"; 
    
    private static var AXIS_X:String = "x";
	private static var AXIS_Y:String = "y";
    
    
    /**
     * Constructor.
     */
    public function SoftBoxParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, box:SoftBox):SoftBox {
    	
    	if (box == null) {
    		box = new SoftBox();	
    	} 
    	
        super.parse(awml, box);
        
        // init axis
        var axis:String = getAttributeAsString(awml, ATTR_AXIS, null);
        switch (axis) {
        	case AXIS_X:
        		box.setAxis(SoftBoxLayout.X_AXIS);
        		break;	
        	case AXIS_Y:
        		box.setAxis(SoftBoxLayout.Y_AXIS);
        		break;	
        }
        
        // init gap
        box.setGap(getAttributeAsNumber(awml, ATTR_GAP, box.getGap()));
        
        return box;
	}
    
}
