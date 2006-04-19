/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.AbstractCellEditor;
import org.aswing.Component;
import org.aswing.JComboBox;
import org.aswing.ListModel;

/**
 * The default editor for table and tree cells, use a combobox.
 * <p>
 * @author iiley
 */
class org.aswing.DefaultComboBoxCellEditor extends AbstractCellEditor{
	
	private var comboBox:JComboBox;
	
	public function DefaultComboBoxCellEditor(){
		super();
		setClickCountToStart(1);
	}
	
	public function getComboBox():JComboBox{
		if(comboBox == null){
			comboBox = new JComboBox();
			comboBox.setFocusable(false);
		}
		return comboBox;
	}
	
 	public function getEditorComponent():Component{
 		return getComboBox();
 	}
	
	public function getCellEditorValue() {
		return getComboBox().getSelectedItem();
	}
	
    /**
     * Sets the value of this cell. 
     * @param value the new value of this cell
     */
	public function setCellEditorValue(value):Void{
		getComboBox().setSelectedItem(value);
	}
	
	public function toString():String{
		return "DefaultComboBoxCellEditor[]";
	}
}