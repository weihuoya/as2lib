/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.TextComponentParser;
import org.aswing.JTextArea;

/**
 * Parses {@link org.aswing.JTextArea} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.TextAreaParser extends TextComponentParser {
    
    private static var ATTR_COLUMNS:String = "columns";
    private static var ATTR_ROWS:String = "rows";
    private static var ATTR_MULTILINE:String = "multiline";
    private static var ATTR_WORD_WRAP:String = "word-wrap";
    
    /**
     * Constructor.
     */
    public function TextAreaParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, text:JTextArea):JTextArea {
    	
    	// create if undefined
    	if (text == null) {
    		text = new JTextArea();	
    	}
    	
        super.parse(awml, text);
        
        // init columns and rows
        text.setColumns(getAttributeAsNumber(awml, ATTR_COLUMNS, text.getColumns()));
        text.setRows(getAttributeAsNumber(awml, ATTR_ROWS, text.getRows()));
        
        // init multiline
        text.setMultiline(getAttributeAsBoolean(awml, ATTR_MULTILINE, text.isMultiline()));
        
        // init word wrap
        text.setWordWrap(getAttributeAsBoolean(awml, ATTR_WORD_WRAP, text.isWordWrap()));
        
        return text;
    }
    
}
