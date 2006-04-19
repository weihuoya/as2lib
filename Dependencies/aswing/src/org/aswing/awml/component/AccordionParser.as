/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.AbstractTabbedPaneParser;
import org.aswing.JAccordion;

/**
 * Parses {@link org.aswing.JAccordion} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.AccordionParser extends AbstractTabbedPaneParser {
    
    /**
     * Constructor.
     */
    public function AccordionParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, accordion:JAccordion):JAccordion {
    	
    	if (accordion == null) {
    		accordion = new JAccordion();	
    	} 
    	
        super.parse(awml, accordion);
        
        return accordion;
	}
    
}
