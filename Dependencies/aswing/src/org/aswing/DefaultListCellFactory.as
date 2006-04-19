/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.DefaultListCell;
import org.aswing.ListCell;
import org.aswing.ListCellFactory;

/**
 * @author iiley
 */
class org.aswing.DefaultListCellFactory implements ListCellFactory {
	
	private var shareCelles:Boolean;
	private var cellHeight:Number;
	
	/**
	 * @param shareCelles is share cells for list items.
	 * @see #isShareCells()
	 */
	public function DefaultListCellFactory(shareCelles:Boolean){
		if(shareCelles == undefined){
			shareCelles = true;
		}
		this.shareCelles = shareCelles;
		cellHeight = -1;
	}
	
	public function createNewCell() : ListCell {
		return new DefaultListCell();
	}
	
	/**
	 * Return true here.
	 * @see ListCellFactory#isAllCellHasSameHeight()
	 */
	public function isAllCellHasSameHeight() : Boolean {
		return true;
	}
	
	/**
	 * @return is share cells for items.
	 * @see ListCellFactory#isShareCells()
	 */
	public function isShareCells() : Boolean {
		return shareCelles;
	}
	
	/**
	 * Returns the height for all cells.
	 * @see ListCellFactory#getCellHeight()
	 */
	public function getCellHeight() : Number {
		if(cellHeight < 0){
			var cell:ListCell = createNewCell();
			cell.setValue("JjHhWpqQ1@|");
			cellHeight = cell.getListCellComponent().getPreferredSize().height;
		}
		return cellHeight;
	}

}
