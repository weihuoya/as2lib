/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AwmlConstants;
import org.aswing.awml.border.BevelBorderParser;
import org.aswing.awml.border.LineBorderParser;
import org.aswing.awml.border.SideLineBorderParser;
import org.aswing.awml.border.SimpleTitledBorderParser;
import org.aswing.awml.common.BoundsParser;
import org.aswing.awml.common.ColorParser;
import org.aswing.awml.common.FontParser;
import org.aswing.awml.common.InsetsParser;
import org.aswing.awml.common.TextFormatParser;
import org.aswing.awml.component.AccordionParser;
import org.aswing.awml.component.AttachPaneParser;
import org.aswing.awml.component.BoxParser;
import org.aswing.awml.component.ButtonParser;
import org.aswing.awml.component.CheckBoxParser;
import org.aswing.awml.component.ComboBoxParser;
import org.aswing.awml.component.FrameParser;
import org.aswing.awml.component.LabelParser;
import org.aswing.awml.component.list.ListItemParser;
import org.aswing.awml.component.list.ListItemsParser;
import org.aswing.awml.component.ListParser;
import org.aswing.awml.component.LoadPaneParser;
import org.aswing.awml.component.PanelParser;
import org.aswing.awml.component.ProgressBarParser;
import org.aswing.awml.component.RadioButtonParser;
import org.aswing.awml.component.ScrollBarParser;
import org.aswing.awml.component.ScrollPaneParser;
import org.aswing.awml.component.SeparatorParser;
import org.aswing.awml.component.SoftBoxParser;
import org.aswing.awml.component.tab.TabParser;
import org.aswing.awml.component.TabbedPaneParser;
import org.aswing.awml.component.text.CSSParser;
import org.aswing.awml.component.text.TextParser;
import org.aswing.awml.component.TextAreaParser;
import org.aswing.awml.component.TextFieldParser;
import org.aswing.awml.component.ToggleButtonParser;
import org.aswing.awml.component.ToolBarParser;
import org.aswing.awml.component.ViewportParser;
import org.aswing.awml.component.WindowParser;
import org.aswing.awml.icon.IconWrapperParser;
import org.aswing.awml.icon.LoadIconParser;
import org.aswing.awml.icon.OffsetIconParser;
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
        
        // TODO JTable support
        
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
        put(AwmlConstants.NODE_SCROLL_BAR, ScrollBarParser);
        put(AwmlConstants.NODE_LIST, ListParser);
        put(AwmlConstants.NODE_COMBO_BOX, ComboBoxParser);
        put(AwmlConstants.NODE_VIEW_PORT, ViewportParser);
        put(AwmlConstants.NODE_SCROLL_PANE, ScrollPaneParser);
        
        put(AwmlConstants.NODE_PANEL, PanelParser);
        put(AwmlConstants.NODE_BOX, BoxParser);
        put(AwmlConstants.NODE_SOFT_BOX, SoftBoxParser);
        put(AwmlConstants.NODE_TOOL_BAR, ToolBarParser);
        put(AwmlConstants.NODE_ATTACH_PANE, AttachPaneParser);
        put(AwmlConstants.NODE_LOAD_PANE, LoadPaneParser);
        
        put(AwmlConstants.NODE_ACCORDION, AccordionParser);
        put(AwmlConstants.NODE_TABBED_PANE, TabbedPaneParser);
        
        put(AwmlConstants.NODE_EMPTY_LAYOUT, EmptyLayoutParser);
        put(AwmlConstants.NODE_FLOW_LAYOUT, FlowLayoutParser);
        put(AwmlConstants.NODE_BOX_LAYOUT, BoxLayoutParser);
        put(AwmlConstants.NODE_SOFT_BOX_LAYOUT, SoftBoxLayoutParser);
        put(AwmlConstants.NODE_GRID_LAYOUT, GridLayoutParser);
        put(AwmlConstants.NODE_BORDER_LAYOUT, BorderLayoutParser);
        
        put(AwmlConstants.NODE_BEVEL_BORDER, BevelBorderParser);
        put(AwmlConstants.NODE_EMPTY_BORDER, EmptyLayoutParser);
        put(AwmlConstants.NODE_LINE_BORDER, LineBorderParser);
        put(AwmlConstants.NODE_SIDE_LINE_BORDER, SideLineBorderParser);
        put(AwmlConstants.NODE_SIMPLE_TITLED_BORDER, SimpleTitledBorderParser);
        
        put(AwmlConstants.NODE_MARGINS, InsetsParser);
        put(AwmlConstants.NODE_INSETS, InsetsParser);
        put(AwmlConstants.NODE_MAXIMIZED_BOUNDS, BoundsParser);
        put(AwmlConstants.NODE_FONT, FontParser);
        put(AwmlConstants.NODE_COLOR, ColorParser);
        put(AwmlConstants.NODE_BACKGROUND, ColorParser);
        put(AwmlConstants.NODE_FOREGROUND, ColorParser);
        put(AwmlConstants.NODE_HIGHLIGHT_INNER_COLOR, ColorParser);
        put(AwmlConstants.NODE_HIGHLIGHT_OUTER_COLOR, ColorParser);
        put(AwmlConstants.NODE_SHADOW_INNER_COLOR, ColorParser);
        put(AwmlConstants.NODE_SHADOW_OUTER_COLOR, ColorParser);
        put(AwmlConstants.NODE_LINE_COLOR, ColorParser);
        put(AwmlConstants.NODE_LINE_LIGHT_COLOR, ColorParser);
        put(AwmlConstants.NODE_TEXT_FORMAT, TextFormatParser);
        
        put(AwmlConstants.NODE_LIST_ITEMS, ListItemsParser);
        put(AwmlConstants.NODE_LIST_ITEM, ListItemParser);
        
        put(AwmlConstants.NODE_TAB, TabParser);
        
        put(AwmlConstants.NODE_TEXT, TextParser);
        put(AwmlConstants.NODE_CSS, CSSParser);
        
        put(AwmlConstants.NODE_ATTACH_ICON, AttachPaneParser);
        put(AwmlConstants.NODE_LOAD_ICON, LoadIconParser);
        put(AwmlConstants.NODE_OFFSET_ICON, OffsetIconParser);
        
        put(AwmlConstants.NODE_ICON, IconWrapperParser);
        put(AwmlConstants.NODE_SELECTED_ICON, IconWrapperParser);
        put(AwmlConstants.NODE_PRESSED_ICON, IconWrapperParser);
        put(AwmlConstants.NODE_DISABLED_ICON, IconWrapperParser);
        put(AwmlConstants.NODE_DISABLED_SELECTED_ICON, IconWrapperParser);
        put(AwmlConstants.NODE_ROLL_OVER_ICON, IconWrapperParser);
        put(AwmlConstants.NODE_ROLL_OVER_SELECTED_ICON, IconWrapperParser);
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
