/* See LICENSE for copyright and terms of use */

import org.actionstep.NSView;
import org.actionstep.NSCell;
import org.actionstep.NSFont;
import org.actionstep.NSFormatter;
import org.actionstep.NSRect;
import org.actionstep.NSText;
import org.actionstep.NSAttributedString;
import org.actionstep.NSEvent;
import org.actionstep.ASUtils;
import org.actionstep.NSApplication;

import org.actionstep.constants.NSTextAlignment;
import org.actionstep.NSException;

/**
 * Base class for all controls. Controls are views with the added concept of
 * cells. A cell is a swappable class that manages the drawing of the control.
 * 
 * Subclassing notes:
 *  * <code>#setCellClass()</code> and <code>#cellClass()</code> must be 
 *    overridden in subclasses.
 *    
 * @author Richard Kilmer
 */
class org.actionstep.NSControl extends NSView {
  
  //******************************************************                               
  //*                  Class members
  //******************************************************  
  
  private static var g_cellClass:Function;
  private static var g_actionCellClass:Function;

  //******************************************************                               
  //*                 Member variables
  //******************************************************
  
  private var m_trackingData:Object;
  private var m_app:NSApplication;
  private var m_target:Object; // for subclasses  
  private var m_cell:NSCell;
  private var m_tag:Number;
  private var m_ignoresMultiClick:Boolean;
  
  //******************************************************                               
  //*                  Construction
  //******************************************************
  
  public function initWithFrame(theFrame:NSRect):NSControl {
    super.initWithFrame(theFrame);
    //doesn't work if in declaration
    m_app = NSApplication.sharedApplication();
    m_cell = new (this.getClass().cellClass())();
    m_cell.init();
    return this;
  }
  
  //******************************************************                               
  //*                 Managing the cell
  //******************************************************
  
  public function cell():NSCell {
    return m_cell;
  }
  
  public function setCell(newCell:NSCell) {
    if (!(newCell instanceof org.actionstep.NSCell)) {
      var e:NSException = NSException.exceptionWithNameReasonUserInfo(
        "NSTypeMismatchException",
        "Provided cell is not an instance of the cell class",
        null);
      trace(e);
      throw e;
    }
    m_cell = newCell;
  }
  
  //******************************************************                               
  //*         Enabling and disabling the control
  //******************************************************
  
  public function setEnabled(value:Boolean) {
    selectedCell().setEnabled(value);
    if (!value) {
      abortEditing();
    }
    setNeedsDisplay(true);
  }
  
  public function isEnabled():Boolean {
    return selectedCell().isEnabled();
  }
  
  //******************************************************                               
  //*            Identifying the selected cell
  //******************************************************
  
  public function selectedCell():NSCell {
    return m_cell;
  }
  
  public function selectedTag():Number {
    var cell:NSCell = selectedCell();
    if (cell == null) {
      return -1;
    }
    return cell.tag();
  }
  
  //******************************************************                               
  //*            Setting the control’s value
  //******************************************************
  
  public function doubleValue():Number {
    return selectedCell().doubleValue();
  }

  public function setDoubleValue(value:Number) {
    abortEditing();
    selectedCell().setDoubleValue(value);
    if(!(selectedCell() instanceof actionCellClass())) {
      setNeedsDisplay(true);
    }
  }

  public function floatValue():Number {
    return selectedCell().floatValue();
  }

  public function setFloatValue(value:Number) {
    abortEditing();
    selectedCell().setFloatValue(value);
    if(!(selectedCell() instanceof actionCellClass())) {
      setNeedsDisplay(true);
    }
  }

  public function intValue():Number {
    return selectedCell().intValue();
  }

  public function setIntValue(value:Number) {
    abortEditing();
    selectedCell().setIntValue(value);
    if(!(selectedCell() instanceof actionCellClass())) {
      setNeedsDisplay(true);
    }
  }

  public function stringValue():String {
    return selectedCell().stringValue();
  }

  public function setStringValue(value:String) {
    abortEditing();
    selectedCell().setStringValue(value);
    if(!(selectedCell() instanceof actionCellClass())) {
      setNeedsDisplay(true);
    }
  }
  
  public function objectValue():String {
    return String(selectedCell().objectValue());
  }

  public function setObjectValue(value:String) {
    abortEditing();
    selectedCell().setObjectValue(value);
    if(!(selectedCell() instanceof actionCellClass())) {
      setNeedsDisplay(true);
    }
  }
  
  //******************************************************                               
  //*          Interacting with other controls
  //******************************************************
  
  public function takeDoubleValueFrom(sender:Object) {
    selectedCell().takeDoubleValueFrom(sender);
    setNeedsDisplay(true);
  }

  public function takeFloatValueFrom(sender:Object) {
    selectedCell().takeFloatValueFrom(sender);
    setNeedsDisplay(true);
  }

  public function takeIntValueFrom(sender:Object) {
    selectedCell().takeIntValueFrom(sender);
    setNeedsDisplay(true);
  }

  public function takeObjectValueFrom(sender:Object) {
    selectedCell().takeObjectValueFrom(sender);
    setNeedsDisplay(true);
  }
  
  public function takeStringValueFrom(sender:Object) {
    selectedCell().takeStringValueFrom(sender);
    setNeedsDisplay(true);
  }
  
  //******************************************************                               
  //*               Formatting text
  //******************************************************
  
  public function alignment():NSTextAlignment {
    if (m_cell != null) {
      return m_cell.alignment();
    } else {
      return NSTextAlignment.NSNaturalTextAlignment;
    }
  }
  
  public function setAlignment(value:NSTextAlignment) {
    if (m_cell != null) {
      abortEditing();
      m_cell.setAlignment(value);
      if(!(m_cell instanceof actionCellClass())) {
        setNeedsDisplay(true);
      }
    }

  }
  
  public function font():NSFont {
    if (m_cell != null) {
      return m_cell.font();
    } else {
      return null;
    }
  }
  
  public function setFont(value:NSFont) {
    var currentEditor:NSText = currentEditor();
    if (m_cell != null) {
      if (currentEditor != null) { 
        currentEditor.setFont(value); 
      }
      m_cell.setFont(value);
    }
  }
  
  public function formatter():NSFormatter {
    return m_cell.formatter();
  }
  
  public function setFormatter(value:NSFormatter) {
    if (m_cell != null) {
      m_cell.setFormatter(value);
      if (!(m_cell instanceof g_actionCellClass)) {
        setNeedsDisplay(true);
      }
    }
  }
  
  //******************************************************                               
  //*             Managing the field editor
  //******************************************************
  
  public function abortEditing():Boolean {
    return false;
  }

  public function currentEditor():NSText {
    return null;
  }
  
  public function validateEditing() { 
  }
  
  //******************************************************                               
  //*               Resizing the control
  //******************************************************
  
  public function calcSize() { 
  }

  public function sizeToFit() { 
    setFrameSize(m_cell.cellSize());
  }
  
  //******************************************************                               
  //*                 Displaying a cell
  //******************************************************
  
  public function selectCell(cell:NSCell) {
    if (cell == m_cell) {
      m_cell.setState(NSCell.NSOnState);
      setNeedsDisplay(true);
    }
  }
  
  public function drawRect(rect:NSRect) {
    drawCell(m_cell);
  }
  
  public function drawCell(cell:NSCell) {
    if (cell == m_cell) {
      mcBounds().clear();
      m_cell.drawWithFrameInView(m_bounds, this);
    }
  }
  
  public function drawCellInside(cell:NSCell) {
    if (cell == m_cell) {
      m_cell.drawInteriorWithFrameInView(m_bounds, this);
    }
  }

  public function updateCell(cell:NSCell) {
    setNeedsDisplay(true);
  }

  public function updateCellInside(cell:NSCell) {
    setNeedsDisplay(true);
  }
  
  //******************************************************                               
  //*     Implementing the target/action mechanism
  //******************************************************
  
  public function action():String {
    return m_cell.action();
  }
  
  public function setAction(value:String) {
    m_cell.setAction(value);
  }
  
  public function target():Object {
    return m_target;
  }
  
  public function setTarget(target:Object) {
    m_target = target;
    m_cell.setTarget(target);
  }
  
  /**
   * Tells the NSApplication to trigger theAction in theTarget.
   *
   * If theAction is null, the call to sendActionTo is ignored. If theTarget
   * is null, NSApplication searches the responder chain for an object that 
   * can respond to the message.
   *
   * This method returns TRUE if a target responds to the message, and FALSE
   * otherwise.
   */
  public function sendActionTo(theAction:String, theTarget:Object):Boolean {
    if (theAction == null) {
      return false;
    }
    return m_app.sendActionToFrom(theAction, theTarget, this);
  }
  
  public function isContinuous():Boolean {
    return m_cell.isContinuous();
  }

  public function setContinuous(c:Boolean) {
    m_cell.setContinuous(c);
  }
  
  public function sendActionOn(mask:Number):Number {
    return m_cell.sendActionOn(mask);
  }
  
  //******************************************************                               
  //*    Getting and setting attributed string values
  //******************************************************
  
  public function setAttributedStringValue(
      attributedStringValue:NSAttributedString):Void {
    var sel:NSCell = selectedCell();
    abortEditing();
    sel.setAttributedStringValue(attributedStringValue);
    if (!(m_cell instanceof g_actionCellClass)) {
      setNeedsDisplay(true);
    }    
  }
  
  public function attributedString():NSAttributedString {
    var sel:NSCell = selectedCell();
    if (sel != null) {
      validateEditing();
      return sel.attributedStringValue();
    } else {
      return new NSAttributedString();
    }
  }

  //******************************************************                               
  //*        Setting and getting cell attributes
  //******************************************************

  public function setTag(value:Number) {
    m_tag = value;
  }

  public function tag():Number {
    return m_tag;
  }
  
  //******************************************************                               
  //*           Activating from the keyboard
  //******************************************************
  
  public function performClick() {
    m_cell.performClickWithFrameInView(bounds(), this);
  }
  
  public function refusesFirstResponder():Boolean {
    return selectedCell().refusesFirstResponder();
  }
  
  public function setRefusesFirstResponder(value:Boolean) {
    selectedCell().setRefusesFirstResponder(value);
  }
  
  public function acceptsFirstResponder():Boolean {
    return selectedCell().acceptsFirstResponder();
  }
  
  //******************************************************                               
  //*              Tracking the mouse
  //******************************************************
  
  private function cellTrackingRect():NSRect {
    return m_bounds;
  }
  
  public function mouseDown(event:NSEvent) {
    if (!isEnabled()) {
      return;
    }
    if (m_ignoresMultiClick && event.clickCount > 1) {
      super.mouseDown(event);
      return;
    }
    // This is necessary because of the async requirements of Flash
    m_cell.setTrackingCallbackSelector(this, "cellTrackingCallback");
    m_trackingData = { 
      mouseDown: true, 
      //actionMask: (m_cell.isContinuous() ? m_cell.sendActionOn(NSEvent.NSPeriodicMask) : m_cell.sendActionOn(0)),
      eventMask: NSEvent.NSLeftMouseDownMask 
        | NSEvent.NSLeftMouseUpMask 
        | NSEvent.NSLeftMouseDraggedMask
        | NSEvent.NSMouseMovedMask  
        | NSEvent.NSOtherMouseDraggedMask 
        | NSEvent.NSRightMouseDraggedMask,
      mouseUp: false, 
      complete: false,
      bounds: cellTrackingRect()
    };
    mouseTrackingCallback(event);
  }
  
  public function cellTrackingCallback(mouseUp:Boolean) {
    //change--set highlight iff mouseUp
    setNeedsDisplay(true);
    if(mouseUp) {
      m_cell.setHighlighted(false);
      //m_cell.sendActionOn(m_trackingData.actionMask);  
      m_cell.setTrackingCallbackSelector(null, null);
    } else {
      m_app.callObjectSelectorWithNextEventMatchingMaskDequeue(this, 
        "mouseTrackingCallback", m_trackingData.eventMask, true);
    }
  }
  
  public function mouseTrackingCallback(event:NSEvent) {
    if (event.type == NSEvent.NSLeftMouseUp) {
      m_cell.setHighlighted(false);
      setNeedsDisplay(true);
      //m_cell.sendActionOn(m_trackingData.actionMask);
      m_cell.setTrackingCallbackSelector(null, null);
      m_cell.mouseTrackingCallback(event);
      return;
    }
    if(event.view == this && cellTrackingRect().pointInRect(
        convertPointFromView(event.mouseLocation, null))) {
      m_cell.setHighlighted(true);
      setNeedsDisplay(true);
      m_cell.trackMouseInRectOfViewUntilMouseUp(event, m_trackingData.bounds, 
        this, m_cell.getClass().prefersTrackingUntilMouseUp());
      return;
    }
    m_app.callObjectSelectorWithNextEventMatchingMaskDequeue(this, 
      "mouseTrackingCallback", m_trackingData.eventMask, true);
  }
  
  public function setIgnoresMultiClick(value:Boolean) {
    m_ignoresMultiClick = value;
  }
  
  public function ignoresMultiClick():Boolean {
    return m_ignoresMultiClick;
  }
 
  //******************************************************                               
  //*             Setting the cell class
  //******************************************************
  
  /**
   * Sets the cell class to <code>klass</code> (must be a subclass of
   * <code>NSCell</code>). An instance of the cell class is instantiated for
   * every new control.
   *
   * NOTE: Must be overridden in subclasses.
   */
  public static function setCellClass(klass:Function) {
    g_cellClass = klass;
  }

  /**
   * Returns the cell class.
   *
   * NOTE: Must be overridden in subclasses.
   */  
  public static function cellClass():Function {
    if (g_cellClass == undefined) {
      g_cellClass = org.actionstep.NSCell;
    }
    return g_cellClass;
  }

  public static function setActionCellClass(klass:Function) {
    g_actionCellClass = klass;
  }

  public static function actionCellClass():Function {
    if (g_actionCellClass == undefined) {
      g_actionCellClass = org.actionstep.NSActionCell;
    }
    return g_actionCellClass;
  }
  
  //******************************************************                               
  //*                 Notifications
  //******************************************************
  
  public static var NSControlTextDidBeginEditingNotification:Number 
    = ASUtils.intern("NSControlTextDidBeginEditingNotification");
  public static var NSControlTextDidChangeNotification:Number 
    = ASUtils.intern("NSControlTextDidChangeNotification");
  public static var NSControlTextDidEndEditingNotification:Number 
    = ASUtils.intern("NSControlTextDidEndEditingNotification");
}