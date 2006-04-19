/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.AbstractButtonParser;
import org.aswing.JButton;

/**
 * Parses {@link org.aswing.JButton} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.ButtonParser extends AbstractButtonParser {
    
    /**
     * Constructor.
     */
    public function ButtonParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, button:JButton):JButton {
    	
    	if (button == null) {
    		button = new JButton();	
    	} 
    	
        super.parse(awml, button);
        
        return button;
	}
    
}
