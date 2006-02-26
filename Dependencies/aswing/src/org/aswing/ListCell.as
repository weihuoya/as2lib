/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.Component;
/**
 * @author iiley
 */
interface org.aswing.ListCell {
	
	/**
	 * Sets the value of this cell.
	 * @param value which should represent on the component of this cell.
	 */
	public function setValue(value:Object):Void;
	
	/**
	 * Returns the value of the cell.
	 * @return the value of the cell.
	 */
	public function getValue():Object;
	
	/**
	 * Sets the cell be selected or not.
	 * @param b true to set the cell selected, false to set not selected.
	 */
	public function setSelected(b:Boolean):Void;
	
	/**
	 * Returns whether the cell is selected.
	 * @return true if the cell is selected, false otherwish.
	 */
	public function isSelected():Boolean;
	
	/**
	 * Return the represent component of this cell.
	 * <p>
	 * You must keep this component trigger enalbed then it can make JList know 
	 * when it is pressed then set it to be selected.
	 * <br>
	 * If it is a <code>Container</code> and has children, suggest to make its all 
	 * children trigger disabled, then it can get mouse clicks.
	 * @return a component that reprensent this cell.
	 * @see Component#setTriggerEnabled()
	 */
	public function getListCellComponent():Component;
	
}
