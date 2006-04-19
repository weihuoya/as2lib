/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.Component;
import org.aswing.JTable;

/**
 * @author iiley
 */
interface org.aswing.table.TableCell {
	/**
	 * Sets the value of this cell.
	 * @param value which should represent on the component of this cell.
	 */
	public function setCellValue(value:Object):Void;
	
	/**
	 * Returns the value of the cell.
	 * @return the value of the cell.
	 */
	public function getCellValue():Object;
	
	/**
	 * Sets the table cell status, include the owner-JTable isSelected, row position, column position.
	 * @param the cell's owner, a JTable
	 * @param isSelected true to set the cell selected, false to set not selected.
	 * @param row the row position
	 * @param column the column position
	 */
	public function setTableCellStatus(table:JTable, isSelected:Boolean, row:Number, column:Number):Void;
	
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
	public function getCellComponent():Component;
}