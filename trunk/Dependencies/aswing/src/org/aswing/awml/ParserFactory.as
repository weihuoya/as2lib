/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AwmlConstants;
import org.aswing.awml.common.InsetsParser;
import org.aswing.awml.component.ButtonParser;
import org.aswing.awml.component.CheckBoxParser;
import org.aswing.awml.component.FrameParser;
import org.aswing.awml.component.LabelParser;
import org.aswing.awml.component.ProgressBarParser;
import org.aswing.awml.component.RadioButtonParser;
import org.aswing.awml.component.SeparatorParser;
import org.aswing.awml.component.TextAreaParser;
import org.aswing.awml.component.TextFieldParser;
import org.aswing.awml.component.ToggleButtonParser;
import org.aswing.awml.component.WindowParser;
import org.aswing.awml.layout.BorderLayoutParser;
import org.aswing.awml.layout.BoxLayoutParser;
import org.aswing.awml.layout.EmptyLayoutParser;
import org.aswing.awml.layout.FlowLayoutParser;
import org.aswing.awml.layout.GridLayoutParser;
import org.aswing.awml.layout.SoftBoxLayoutParser;
import org.aswing.util.ArrayUtils;

/**
 * Configures dependencies between AWML elements, objects and parsers. Provides 
 * routines to obtain required parsers. 
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.ParserFactory {
	
	/** Singleton holder property. */
	private static var instance:ParserFactory;
	
	/** Holds AWML node names associated with appropriate parsers. */
	private var parserNames:Array;
	
	/** Holds parser classes */
	private var parserClasses:Array;
	
	/** Holds parser instances. */
	private var parserInstances:Array;
	
	
	/**
	 * Creates singleton instance.
	 * 
	 * @return singleton instance.
	 */
	public static function getInstance(Void):ParserFactory { 
		if (instance == null) {
			instance = new ParserFactory();	
		}
		return instance;	
	}
	
	/**
	 * Private Constructor.
	 */
	private function ParserFactory(Void) {
		parserNames = new Array();
		parserClasses = new Array();
		parserInstances = new Array();
		
		// init parsers 
		put(AwmlConstants.NODE_FRAME, FrameParser);
		put(AwmlConstants.NODE_WINDOW, WindowParser);
		put(AwmlConstants.NODE_TEXT_AREA, TextAreaParser);
		put(AwmlConstants.NODE_TEXT_FIELD, TextFieldParser);
		put(AwmlConstants.NODE_SEPARATOR, SeparatorParser);
		put(AwmlConstants.NODE_PROGRESS_BAR, ProgressBarParser);
		put(AwmlConstants.NODE_LABEL, LabelParser);
		put(AwmlConstants.NODE_BUTTON, ButtonParser);
		put(AwmlConstants.NODE_TOGGLE_BUTTON, ToggleButtonParser);
		put(AwmlConstants.NODE_CHECK_BOX, CheckBoxParser);
		put(AwmlConstants.NODE_RADIO_BUTTON, RadioButtonParser);
		
		put(AwmlConstants.NODE_EMPTY_LAYOUT, EmptyLayoutParser);
		put(AwmlConstants.NODE_FLOW_LAYOUT, FlowLayoutParser);
		put(AwmlConstants.NODE_BOX_LAYOUT, BoxLayoutParser);
		put(AwmlConstants.NODE_SOFT_BOX_LAYOUT, SoftBoxLayoutParser);
		put(AwmlConstants.NODE_GRID_LAYOUT, GridLayoutParser);
		put(AwmlConstants.NODE_BORDER_LAYOUT, BorderLayoutParser);
		
		put(AwmlConstants.NODE_MARGINS, InsetsParser);
	}
	
	/**
	 * Associates parser class with AWML node name.
	 * 
	 * @param parserName the AWML node name.
	 * @param parserClass the parser class responsible for AWML node parsing. 
	 */
	public function put(parserName:String, parserClass:Function):Void {
		if (parserClass == null || parserName == null || parserName == "") return;
		
		parserNames.push(parserName);
		parserClasses.push(parserClass);
	}

	/**
	 * Gets parser instance by AWML node name.
	 * 
	 * @param parserName the AWML node name.
	 * @return parser instance.
	 */
	public function get(parserName:String) {
		var index:Number = ArrayUtils.indexInArray(parserNames, parserName);
		if (index == -1) return null;
		
		if (parserInstances[index] == null) {
			parserInstances[index] = new parserClasses[index]();	
		}	
		
		return parserInstances[index];
	} 	
}
