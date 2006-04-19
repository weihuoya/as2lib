/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AwmlConstants;
import org.aswing.awml.AwmlParser;
import org.aswing.awml.component.ComponentParser;
import org.aswing.Insets;
import org.aswing.JList;

/**
 * Parses {@link org.aswing.JList} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.ListParser extends ComponentParser {
    
    private static var ATTR_SELECTION_MODE:String = "selection-mode";
    private static var ATTR_FIRST_VISIBLE_INDEX:String = "first-visible-index";
    private static var ATTR_LAST_VISIBLE_INDEX:String = "last-visible-index";
    private static var ATTR_SELECTED_INDEX:String = "selected-index";
    private static var ATTR_SELECTED_INDICES:String = "selected-indices";
    private static var ATTR_SELECTED_ITEM:String = "selected-item";
    private static var ATTR_PREFFERED_WIDTH_FOR_SHARED_CELLS:String = "preffered-width-for-shared-cells";
    
    private static var MODE_SINGLE:String = "single";
	private static var MODE_MULTIPLE:String = "multiple";
    
    
    /**
     * Constructor.
     */
    public function ListParser(Void) {
        super();
    }
    
    public function parse(awml:XMLNode, list:JList):JList {
    	
    	if (list == null) {
    		list = new JList();	
    	} 
    	
        super.parse(awml, list);
        
        // init selection mode
        var mode:String = getAttributeAsString(awml, ATTR_SELECTION_MODE, null);
        switch (mode) {
        	case MODE_SINGLE:
        		list.setSelectionMode(JList.SINGLE_SELECTION);
        		break;	
        	case MODE_MULTIPLE:
        		list.setSelectionMode(JList.MULTIPLE_SELECTION);
        		break;	
        }
        
        //TODO selected items support 
        
        // init first and last visible indices
        list.setFirstVisibleIndex(getAttributeAsNumber(awml, ATTR_FIRST_VISIBLE_INDEX, list.getFirstVisibleIndex()));
        list.setLastVisibleIndex(getAttributeAsNumber(awml, ATTR_LAST_VISIBLE_INDEX, list.getLastVisibleIndex()));
        list.setSelectedValue(getAttributeAsString(awml, ATTR_SELECTED_ITEM, list.getSelectedValue().toString()));
        
        // init shared cells
        list.setPreferredWidthWhenNoCount(getAttributeAsNumber(awml, ATTR_PREFFERED_WIDTH_FOR_SHARED_CELLS, 
        		list.getPreferredWidthWhenNoCount()));
        
        // init selected indices
        list.setSelectedIndex(getAttributeAsNumber(awml, ATTR_SELECTED_INDEX, list.getSelectedIndex()));
        list.setSelectedIndices(getAttributeAsArray(awml, ATTR_SELECTED_INDICES, list.getSelectedIndices()));
        
        return list;
	}
    
	private function parseChild(awml:XMLNode, nodeName:String, list:JList):Void {

		super.parseChild(awml, nodeName, list);
		
		switch (nodeName) {
			case AwmlConstants.NODE_LIST_ITEMS:
				var collection:Array = AwmlParser.parse(awml);
				if (collection != null) list.setListData(collection);
				break;
		}
	}
    
}
