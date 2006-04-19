/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.AbstractButtonParser;
import org.aswing.JToggleButton;
import org.aswing.awml.ButtonGroupManager;

/**
 * Parses {@link org.aswing.JToggleButton} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.ToggleButtonParser extends AbstractButtonParser {
    
    private static var ATTR_SELECTED:String = "selected";
    private static var ATTR_GROUP_ID:String = "group-id";
    
    /**
     * Constructor.
     */
    public function ToggleButtonParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, button:JToggleButton):JToggleButton {
    	
    	if (button == null) {
    		button = new JToggleButton();	
    	} 
    	
        super.parse(awml, button);
        
        // init selected
        button.setSelected(getAttributeAsBoolean(awml, ATTR_SELECTED, button.isSelected()));
        
        // init button group by id
		var groupName:String = getAttributeAsString(awml, ATTR_GROUP_ID, null);
		ButtonGroupManager.append(groupName, button);        
        
        return button;
	}
    
}
