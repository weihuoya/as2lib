/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AwmlParser;
import org.aswing.awml.AwmlUtils;
import org.aswing.awml.component.ComponentParser;
import org.aswing.Icon;
import org.aswing.JProgressBar;

/**
 * Parses {@link org.aswing.JProgressBar} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.ProgressBarParser extends ComponentParser {
    
    private static var ATTR_ORIENTATION:String = "orientation";
    private static var ATTR_MINIMUM:String = "minimum";
    private static var ATTR_MAXIMUM:String = "maximum";
    private static var ATTR_VALUE:String = "value";
    private static var ATTR_INDETERMINATE:String = "indeterminate";
    
    private static var ORIENTATION_HORIZONTAL:String = "horizontal";
    private static var ORIENTATION_VERTICAL:String = "vertical";
     
    
    /**
     * Constructor.
     */
    public function ProgressBarParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, progress:JProgressBar):JProgressBar {
    	
    	if (progress == null) {
    		progress = new JProgressBar();	
    	} 
    	
        super.parse(awml, progress);
        
        // init orientation
        var orientation:String = getAttributeAsString(awml, ATTR_ORIENTATION);
        switch (orientation) {
        	case ORIENTATION_HORIZONTAL:
        		progress.setOrientation(JProgressBar.HORIZONTAL);
        		break;
        	case ORIENTATION_VERTICAL:
        		progress.setOrientation(JProgressBar.VERTICAL);
        		break;	
        }
        
        // init min, max and value
        progress.setMinimum(getAttributeAsNumber(awml, ATTR_MINIMUM, progress.getMinimum()));
        progress.setMaximum(getAttributeAsNumber(awml, ATTR_MAXIMUM, progress.getMaximum()));
        progress.setValue(getAttributeAsNumber(awml, ATTR_VALUE, progress.getValue()));
        
        // init indeterminate
        progress.setIndeterminate(getAttributeAsBoolean(awml, ATTR_INDETERMINATE, progress.isIndeterminate()));
        
        return progress;
	}
	
    private function parseChild(awml:XMLNode, nodeName:String, progress:JProgressBar):Void {
    	super.parseChild(awml, nodeName, progress);
    	
		if (AwmlUtils.isIconNode(nodeName)) {
    		var icon:Icon = AwmlParser.parse(awml);
    		if (icon != null) progress.setIcon(icon);	
    	}
    }
    
}
