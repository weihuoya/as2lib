/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.ASColor;
import org.aswing.Component;
import org.aswing.geom.Dimension;
import org.aswing.geom.Point;
import org.aswing.geom.Rectangle;
import org.aswing.graphics.Brush;
import org.aswing.graphics.Graphics;
import org.aswing.graphics.Pen;
import org.aswing.graphics.SolidBrush;
import org.aswing.Insets;
import org.aswing.JList;
import org.aswing.JTable;
import org.aswing.ListSelectionModel;
import org.aswing.LookAndFeel;
import org.aswing.plaf.TableUI;
import org.aswing.plaf.UIResource;
import org.aswing.table.TableColumn;
import org.aswing.table.TableColumnModel;
import org.aswing.UIManager;
import org.aswing.util.Delegate;

/**
 * @author iiley
 */
class org.aswing.plaf.basic.BasicTableUI extends TableUI {
	
	private var table:JTable;
	private var tableListener:Object;
	private var mouseListener:Object;
	
	public function BasicTableUI() {
		super();
	}
	
    public function installUI(c:Component):Void {
        table = JTable(c);
        installDefaults();
        installListeners();
    }
    
    private function installDefaults():Void {
    	var pp:String = "Table.";
        LookAndFeel.installColorsAndFont(table, pp + "background", pp + "foreground", pp + "font");
        LookAndFeel.installBorder(table, pp+"border");
        LookAndFeel.installBasicProperties(table, pp);
        
		var sbg:ASColor = table.getSelectionBackground();
		if (sbg === undefined || sbg instanceof UIResource) {
			table.setSelectionBackground(UIManager.getColor("Table.selectionBackground"));
		}

		var sfg:ASColor = table.getSelectionForeground();
		if (sfg === undefined || sfg instanceof UIResource) {
			table.setSelectionForeground(UIManager.getColor("Table.selectionForeground"));
		}

		var gridColor:ASColor = table.getGridColor();
		if (gridColor === undefined || gridColor instanceof UIResource) {
			table.setGridColor(UIManager.getColor("Table.gridColor"));
		}
    }
    private function installListeners():Void{
    	tableListener = new Object();
    	tableListener[JTable.ON_PRESS] = Delegate.create(this, __onTablePress);
    	tableListener[JTable.ON_RELEASE] = Delegate.create(this, __onTableRelease);
    	tableListener[JTable.ON_RELEASEOUTSIDE] = Delegate.create(this, __onTableReleasedOutside);
    	tableListener[JTable.ON_CLICKED] = Delegate.create(this, __onTableClicked);
    	tableListener[JList.ON_MOUSE_WHEEL] = Delegate.create(this, __onTableMouseWheel);
    	table.addEventListener(tableListener);
    	
    	mouseListener = {onMouseMove:Delegate.create(this, __onTableMouseMove)};
    }
	
	public function uninstallUI(c:Component):Void {
        uninstallDefaults();
        uninstallListeners();
    }
    
    private function uninstallDefaults():Void {
        LookAndFeel.uninstallBorder(table);
    }
    private function uninstallListeners():Void{
    }
    
    private function __onTablePress():Void{
    	selectMousePointed();
		Mouse.addListener(mouseListener);
		table.getCellEditor().stopCellEditing();
    }
    
    private function __onTableClicked(source:JTable, clickCount:Number):Void{
    	var p:Point = getMousePosOnTable();
    	var row:Number = table.rowAtPoint(p);
    	var column:Number = table.columnAtPoint(p);
    	if(table.editCellAt(row, column, clickCount)){
    	}
    }
    
    private function __onTableRelease():Void{
    	Mouse.removeListener(mouseListener);
    }
    
    private function __onTableReleasedOutside():Void{
    	Mouse.removeListener(mouseListener);
    }
	
	private function __onTableMouseMove():Void{
		addSelectMousePointed();
	}
	
	private function __onTableMouseWheel(source:JTable, delta:Number):Void{
    	var viewPos:Point = table.getViewPosition();
    	viewPos.y -= delta*table.getVerticalUnitIncrement();
    	table.setViewPosition(viewPos);
    }
	
	private function selectMousePointed():Void{
    	var p:Point = getMousePosOnTable();
    	var row:Number = table.rowAtPoint(p);
    	var column:Number = table.columnAtPoint(p);
		if ((column == -1) || (row == -1)) {
			return;
		}
		makeSelectionChange(row, column);
	}
	
	private function addSelectMousePointed():Void{
    	var p:Point = getMousePosOnTable();
    	var row:Number = table.rowAtPoint(p);
    	var column:Number = table.columnAtPoint(p);
		if ((column == -1) || (row == -1)) {
			return;
		}
		table.changeSelection(row, column, false, true);
	}
	
	private function makeSelectionChange(row:Number, column:Number):Void {
		var ctrl:Boolean = Key.isDown(Key.CONTROL);
		var shift:Boolean = Key.isDown(Key.SHIFT);

		// Apply the selection state of the anchor to all cells between it and the
		// current cell, and then select the current cell.
		// For mustang, where API changes are allowed, this logic will moved to
		// JTable.changeSelection()
		if (ctrl && shift) {
			var rm:ListSelectionModel = table.getSelectionModel();
			var cm:ListSelectionModel = table.getColumnModel().getSelectionModel();
			var anchorRow:Number = rm.getAnchorSelectionIndex();
			var anchorCol:Number = cm.getAnchorSelectionIndex();

			if (table.isCellSelected(anchorRow, anchorCol)) {
				rm.addSelectionInterval(anchorRow, row);
				cm.addSelectionInterval(anchorCol, column);
			} else {
				rm.removeSelectionInterval(anchorRow, row);
				rm.addSelectionInterval(row, row);
				rm.setAnchorSelectionIndex(anchorRow);
				cm.removeSelectionInterval(anchorCol, column);
				cm.addSelectionInterval(column, column);
				cm.setAnchorSelectionIndex(anchorCol);
			}
		} else {
			table.changeSelection(row, column, ctrl, !ctrl && shift);
		}
	}	
	
	private function getMousePosOnTable():Point{
		var p:Point = table.getMousePosition();
		return table.getLogicLocationFromPixelLocation(p);
	}
		
	public function paint(c:Component, g:Graphics, b:Rectangle):Void{
		super.paint(c, g, b);
		table.clearChildrenGraphics();
		g = table.getChildrenGraphics();
		var rowCount:Number = table.getRowCount();
		var columnCount:Number = table.getColumnCount();
		if (rowCount <= 0 || columnCount <= 0) {
			return;
		}
		var extentSize:Dimension = table.getExtentSize();
		var viewPos:Point = table.getViewPosition();
		var startX:Number = b.x - viewPos.x;
		var startY:Number = b.y - viewPos.y + table.getHeaderHeight();
				
		var vb:Rectangle = new Rectangle();
		vb.setSize(extentSize);
		vb.setLocation(viewPos);
		var upperLeft:Point = vb.getLocation();
		var lowerRight:Point = vb.rightBottom();
		var rMin:Number = table.rowAtPoint(upperLeft);
		var rMax:Number = table.rowAtPoint(lowerRight);
		if (rMin == -1) {
			rMin = 0;
		}
		if (rMax == -1) {
			rMax = rowCount - 1;
		}
		var cMin:Number = table.columnAtPoint(upperLeft);
		var cMax:Number = table.columnAtPoint(lowerRight);
		if (cMin == -1) {
			cMin = 0;
		}
		if (cMax == -1) {
			cMax = columnCount - 1;
		}
		
		var minCell:Rectangle = table.getCellRect(rMin, cMin, true);
		var maxCell:Rectangle = table.getCellRect(rMax, cMax, true);
		var damagedArea:Rectangle = minCell.union(maxCell);
		damagedArea.setLocation(damagedArea.getLocation().move(startX, startY));
		
		var pen:Pen = new Pen(table.getGridColor(), 1);
		var brush:Brush = new SolidBrush(table.getSelectionBackground());
		if (table.getShowHorizontalLines()) {
			var x1:Number = damagedArea.x + 0.5;
			var x2:Number = damagedArea.x + damagedArea.width - 1;
			var y:Number = damagedArea.y;
			
			g.drawLine(pen, x1, y+0.5, x2, y+0.5);
			for (var row:Number = rMin; row <= rMax; row++) {
				var rh:Number = table.getRowHeight();
				y += rh;
				if(row == rMax){
					y -= 0.5;
				}
				g.drawLine(pen, x1, y, x2, y);
			}
		}
		if (table.getShowVerticalLines()) {
			var cm:TableColumnModel = table.getColumnModel();
			var x:Number = damagedArea.x + 0.5;
			var y1:Number = damagedArea.y + 0.5;
			var y2:Number = y1 + damagedArea.height -1;
			g.drawLine(pen, x, y1, x, y2);
			x -= 0.5;
			for (var column:Number = cMin; column <= cMax; column++) {
				var w:Number = cm.getColumn(column).getWidth();
				x += w;
				if(column == cMax){
					x -= 0.5;
				}
				g.drawLine(pen, x, y1, x, y2);
			}
		}		
	}	
	//******************************************************************
	//	                         Size Methods
	//******************************************************************

	private function createTableSize(width:Number):Dimension {
		var height:Number = 0;
		var rowCount:Number = table.getRowCount();
		if (rowCount > 0 && table.getColumnCount() > 0) {
			var r:Rectangle = table.getCellRect(rowCount - 1, 0, true);
			height = r.y + r.height;
		}
		height += table.getTableHeader().getPreferredHeight();
		return table.getInsets().roundsSize(new Dimension(width, height));
	}

	/**
	 * Return the minimum size of the table. The minimum height is the
	 * row height times the number of rows.
	 * The minimum width is the sum of the minimum widths of each column.
	 */
	public function getMinimumSize(c:Component):Dimension {
		var width:Number = 0;
		var enumeration:Array = table.getColumnModel().getColumns();
		for(var i:Number=0; i<enumeration.length; i++){
			var aColumn:TableColumn = TableColumn(enumeration[i]);
			width = width + aColumn.getMinWidth();
		}
		return table.getInsets().roundsSize(new Dimension(width, 0));
	}

	/**
	 * Return the preferred size of the table. The preferred height is the
	 * row height times the number of rows.
	 * The preferred width is the sum of the preferred widths of each column.
	 */
	public function getPreferredSize(c:Component):Dimension {
		var width:Number = 0;
		var enumeration:Array = table.getColumnModel().getColumns();
		for(var i:Number=0; i<enumeration.length; i++){
			var aColumn:TableColumn = TableColumn(enumeration[i]);
			width = width + aColumn.getPreferredWidth();
		}
		return createTableSize(width);
	}

	/**
	 * Return the maximum size of the table. The maximum height is the
	 * row heighttimes the number of rows.
	 * The maximum width is the sum of the maximum widths of each column.
	 */
	public function getMaximumSize(c:Component):Dimension {
		var width:Number = 0;
		var enumeration:Array = table.getColumnModel().getColumns();
		for(var i:Number=0; i<enumeration.length; i++){
			var aColumn:TableColumn = TableColumn(enumeration[i]);
			width = width + aColumn.getMaxWidth();
		}
		return createTableSize(width);
	}	
	
	public function toString():String{
		return "BasicTableUI[]";
	}
}