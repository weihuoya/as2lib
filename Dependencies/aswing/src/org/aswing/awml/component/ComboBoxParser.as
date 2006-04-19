/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AwmlConstants;
import org.aswing.awml.AwmlParser;
import org.aswing.awml.component.ComponentParser;
import org.aswing.Insets;
import org.aswing.JList;
import org.aswing.JComboBox;

/**
 * Parses {@link org.aswing.JComboBox} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.ComboBoxParser extends ComponentParser {
    
    private static var ATTR_EDITABLE:String = "editable";
    private static var ATTR_SELECTED_INDEX:String = "selected-index";
    private static var ATTR_SELECTED_ITEM:String = "selected-item";
    private static var ATTR_MAXIMUM_ROW_COUNT:String = "maximum-row-count";
    private static var ATTR_POPUP_VISIBLE:String = "popup-visible";
    
    
    /**
     * Constructor.
     */
    public function ComboBoxParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, combo:JComboBox):JComboBox {
    	
    	if (combo == null) {
    		combo = new JComboBox();	
    	} 
    	
        super.parse(awml, combo);
        
        // init selected index
        combo.setSelectedIndex(getAttributeAsNumber(awml, ATTR_SELECTED_INDEX, combo.getSelectedIndex()));
        
        // init editable
        combo.setEditable(getAttributeAsBoolean(awml, ATTR_EDITABLE, combo.isEditable()));
        
        // init selected item
        combo.setSelectedItem(getAttributeAsString(awml, ATTR_SELECTED_ITEM, combo.getSelectedItem().toString()));
        
        // init maximim rows
        combo.setMaximumRowCount(getAttributeAsNumber(awml, ATTR_MAXIMUM_ROW_COUNT, combo.getMaximumRowCount()));
        
        // init show popup
        combo.setPopupVisible(getAttributeAsBoolean(awml, ATTR_POPUP_VISIBLE, combo.isPopupVisible())); 
        
        return combo;
	}
    
	private function parseChild(awml:XMLNode, nodeName:String, combo:JComboBox):Void {

		super.parseChild(awml, nodeName, combo);
		
		switch (nodeName) {
			case AwmlConstants.NODE_LIST_ITEMS:
				var collection:Array = AwmlParser.parse(awml);
				if (collection != null) combo.setListData(collection);
				break;
		}
	}
    
}
