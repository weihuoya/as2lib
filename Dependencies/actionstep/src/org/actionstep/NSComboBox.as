/* See LICENSE for copyright and terms of use */

import org.actionstep.NSTextField;
import org.actionstep.NSComboBoxCell;
import org.actionstep.NSSize;
import org.actionstep.NSArray;
import org.actionstep.NSRect;
import org.actionstep.NSPoint;
import org.actionstep.NSEvent;
import org.actionstep.NSComboBoxCellDataSource;

class org.actionstep.NSComboBox extends NSTextField {
  private static var g_cellClass:Function = NSComboBoxCell;

  public static function cellClass():Function {
    return g_cellClass;
  }

  public static function setCellClass(cellClass:Function) {
    if (cellClass == null) {
      g_cellClass = NSComboBoxCell;
    } else {
      g_cellClass = cellClass;
    }
  }
  
  public function NSComboBox() {
  }
  
  public function initWithFrame(rect:NSRect):NSComboBox {
    return NSComboBox(super.initWithFrame(rect));
  }
  
  // Setting display attributes
  
  public function hasVerticalScroller():Boolean {
    return NSComboBoxCell(m_cell).hasVerticalScroller();
  }
  
  public function intercellSpacing():NSSize {
    return NSComboBoxCell(m_cell).intercellSpacing();
  }
  
  public function isButtonBordered():Boolean {
    return NSComboBoxCell(m_cell).isButtonBordered();
  }
  
  public function itemHeight():Number {
    return NSComboBoxCell(m_cell).itemHeight();
  }
  
  public function numberOfVisibleItems():Number {
    return NSComboBoxCell(m_cell).numberOfVisibleItems();
  }
  
  public function setButtonBordered(value:Boolean) {
    NSComboBoxCell(m_cell).setButtonBordered(value);
    setNeedsDisplay(true);
  }
  
  public function setHasVerticalScroller(value:Boolean) {
    NSComboBoxCell(m_cell).setHasVerticalScroller(value);
  }
  
  public function setIntercellSpacing(spacing:NSSize) {
    NSComboBoxCell(m_cell).setIntercellSpacing(spacing);
  }
  
  public function setItemHeight(height:Number) {
    NSComboBoxCell(m_cell).setItemHeight(height);
  }
  
  public function setNumberOfVisibleItems(value:Number) {
    NSComboBoxCell(m_cell).setNumberOfVisibleItems(value);
  }
  
  // Setting a data source
  
  public function dataSource():NSComboBoxCellDataSource {
    return NSComboBoxCell(m_cell).dataSource();
  } 
  
  public function setDataSource(object:NSComboBoxCellDataSource) {
    NSComboBoxCell(m_cell).setDataSource(object);
  }
  
  public function setUsesDataSource(value:Boolean) {
    NSComboBoxCell(m_cell).setUsesDataSource(value);
  }
  
  public function usesDataSource():Boolean {
    return NSComboBoxCell(m_cell).usesDataSource();
  }
  
  public function addItemsWithObjectValues(objects:NSArray) {
    NSComboBoxCell(m_cell).addItemsWithObjectValues(objects);
  }
  
  public function addItemWithObjectValue(object:Object) {
    NSComboBoxCell(m_cell).addItemWithObjectValue(object);
  }
  
  public function insertItemWithObjectValueAtIndex(object:Object, index:Number) {
    NSComboBoxCell(m_cell).insertItemWithObjectValueAtIndex(object, index);
  }
  
  public function objectValues():NSArray {
    return NSComboBoxCell(m_cell).objectValues();
  }
  
  public function removeAllItems() {
    NSComboBoxCell(m_cell).removeAllItems();
  }
  
  public function removeItemAtIndex(index:Number) {
    NSComboBoxCell(m_cell).removeItemAtIndex(index);
  }
  
  public function removeItemWithObjectValue(object:Object) {
    NSComboBoxCell(m_cell).removeItemWithObjectValue(object);
  }
  
  public function numberOfItems():Number {
    return NSComboBoxCell(m_cell).numberOfItems();
  }
  
  // Manipulating the displayed list
  
  public function indexOfItemWithObjectValue(object:Object):Number {
    return NSComboBoxCell(m_cell).indexOfItemWithObjectValue(object);
  }
  
  public function itemObjectValueAtIndex(index:Number):Object {
    return NSComboBoxCell(m_cell).itemObjectValueAtIndex(index);
  }
  
  public function noteNumberOfItemsChanged() {
    NSComboBoxCell(m_cell).noteNumberOfItemsChanged();
  }
  
  public function reloadData() {
    NSComboBoxCell(m_cell).reloadData();
  }
  
  public function scrollItemAtIndexToTop(index:Number) {
    NSComboBoxCell(m_cell).scrollItemAtIndexToTop(index);
  }
  
  public function scrollItemAtIndexToVisible(index:Number) {
    NSComboBoxCell(m_cell).scrollItemAtIndexToVisible(index);
  }
  
  // Manipulating the selection
  
  public function deselectItemAtIndex(index:Number) {
    NSComboBoxCell(m_cell).deselectItemAtIndex(index);
  }
  
  public function indexOfSelectedItem():Number {
    return NSComboBoxCell(m_cell).indexOfSelectedItem();
  }
  
  public function objectValueOfSelectedItem():Object {
    return NSComboBoxCell(m_cell).objectValueOfSelectedItem();
  }
  
  public function selectItemAtIndex(index:Number) {
    NSComboBoxCell(m_cell).selectItemAtIndex(index);
  }
  
  public function selectItemWithObjectValue(object:Object) {
    NSComboBoxCell(m_cell).selectItemWithObjectValue(object);
  }
  
  // Completing the text field
  
  public function completes():Boolean {
    return NSComboBoxCell(m_cell).completes();
  }
  
  public function setCompletes(value:Boolean) {
    NSComboBoxCell(m_cell).setCompletes(value);
  }

  // Handle events

  public function mouseDown(event:NSEvent) {
    if (!isSelectable()) {
      super.mouseDown(event);
      return;
    }
    m_window.makeFirstResponder(this);
    var location:NSPoint = event.mouseLocation;
    location = convertPointFromView(location, null);
    if (NSComboBoxCell(m_cell).isPointInDropDownButton(location)) {
      NSComboBoxCell(m_cell).showListWindow();
    }
  }

  public function keyDown(event:NSEvent) {
    var mods:Number = event.modifierFlags;
    var char:Number = event.keyCode;

    switch (char) {
      case NSUpArrowFunctionKey:
      case NSDownArrowFunctionKey:
        NSComboBoxCell(m_cell).showListWindow();
        return;
    }
    super.keyDown(event);
  }


}