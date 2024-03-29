﻿/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.ComponentParser;
import org.aswing.JTextComponent;
import org.aswing.awml.AwmlConstants;
import org.aswing.ASTextFormat;
import org.aswing.awml.AwmlParser;
import TextField.StyleSheet;
import org.aswing.awml.CSSLoadManager;

/**
 * Parses {@link org.aswing.JTextComponent} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.TextComponentParser extends ComponentParser {
    
    private static var ATTR_EDITABLE:String = "editable";
    private static var ATTR_HTML:String = "html";
    private static var ATTR_TEXT:String = "text";
    private static var ATTR_MAX_CHARS:String = "max-chars";
    private static var ATTR_PASSWORD:String = "password";
    private static var ATTR_RESTRICT:String = "restrict";
    private static var ATTR_CSS_FILE:String = "css-file";
    
    /**
     * Private Constructor.
     */
    private function TextComponentParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, text:JTextComponent):JTextComponent {
        super.parse(awml, text);
        
        // init editable
        text.setEditable(getAttributeAsBoolean(awml, ATTR_EDITABLE, text.isEditable()));
        
        // init html
        text.setHtml(getAttributeAsBoolean(awml, ATTR_HTML, text.isHtml()));
        
        // init text
        text.setText(getAttributeAsString(awml, ATTR_TEXT, text.getText()));    
        
        // init max chars
        text.setMaxChars(getAttributeAsNumber(awml, ATTR_MAX_CHARS, text.getMaxChars()));
        
        // init password
        text.setPasswordField(getAttributeAsBoolean(awml, ATTR_PASSWORD, text.isPasswordField()));
        
        // init restrict
        text.setRestrict(getAttributeAsString(awml, ATTR_RESTRICT, text.getRestrict()));
        
        // init css file
        var cssURL:String = getAttributeAsString(awml, ATTR_CSS_FILE, null);
        if (cssURL != null) {
        	CSSLoadManager.load(cssURL, text);	
        }

        return text;
    }
    
    private function parseChild(awml:XMLNode, nodeName:String, text:JTextComponent):Void {
        
        super.parseChild(awml, nodeName, text);
        
        switch (nodeName) {
            case AwmlConstants.NODE_TEXT_FORMAT:
                var format:ASTextFormat = AwmlParser.parse(awml);
                if (format != null) text.setTextFormat(format);
                break;
            case AwmlConstants.NODE_TEXT:
            	var t:String = AwmlParser.parse(awml);
            	if (t != null) text.setText(t);
            	break;  
            case AwmlConstants.NODE_CSS:
            	var css:StyleSheet = AwmlParser.parse(awml);
            	if (css != null) text.setCSS(css);
            	break;  
        }
    }
    
}
