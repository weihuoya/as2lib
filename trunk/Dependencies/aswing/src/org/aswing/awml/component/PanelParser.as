/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.ContainerParser;
import org.aswing.JPanel;

/**
 * Parses {@link org.aswing.JPanel} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.PanelParser extends ContainerParser {
    
    /**
     * Constructor.
     */
    public function PanelParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, panel:JPanel):JPanel {
    	
    	if (panel == null) {
    		panel = new JPanel();	
    	} 
    	
        super.parse(awml, panel);
        
        return panel;
	}
    
}
