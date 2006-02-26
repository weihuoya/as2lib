/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.ToggleButtonParser;
import org.aswing.JRadioButton;

/**
 * Parses {@link org.aswing.JRadioButton} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.RadioButtonParser extends ToggleButtonParser {
    
    /**
     * Constructor.
     */
    public function RadioButtonParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, radio:JRadioButton):JRadioButton {
    	
    	if (radio == null) {
    		radio = new JRadioButton();	
    	} 
    	
        super.parse(awml, radio);
        
        return radio;
	}
    
}
