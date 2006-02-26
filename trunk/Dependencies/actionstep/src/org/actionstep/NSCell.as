/* See LICENSE for copyright and terms of use */

import org.actionstep.ASDraw;
import org.actionstep.ASFieldEditor;
import org.actionstep.constants.NSBorderType;
import org.actionstep.constants.NSCellAttribute;
import org.actionstep.constants.NSCellType;
import org.actionstep.constants.NSComparisonResult;
import org.actionstep.constants.NSControlSize;
import org.actionstep.constants.NSLineBreakMode;
import org.actionstep.constants.NSTextAlignment;
import org.actionstep.NSApplication;
import org.actionstep.NSArray;
import org.actionstep.NSAttributedString;
import org.actionstep.NSColor;
import org.actionstep.NSControl;
import org.actionstep.NSEvent;
import org.actionstep.NSException;
import org.actionstep.NSFont;
import org.actionstep.NSFormatter;
import org.actionstep.NSImage;
import org.actionstep.NSMenu;
import org.actionstep.NSNumber;
import org.actionstep.NSObject;
import org.actionstep.NSPoint;
import org.actionstep.NSRange;
import org.actionstep.NSRect;
import org.actionstep.NSSize;
import org.actionstep.NSTimer;
import org.actionstep.NSView;

/**
 * This is the base class for for displaying images and text.
 * 
 * Cells are used heavily by NSControl subclasses.
 * 
 * Implementation notes:
 * -Cocoa's editWithFrameInViewEditorDelegateEvent() method is called
 *  editWithEditorDelegateEvent() in ActionStep.
 * -Cocoa's selectWithFrameInViewEditorDelegateStartLength() method is called
 *  selectWithEditorDelegateStartLength() in ActionStep.
 * @author Richard Kilmer
 */
class org.actionstep.NSCell extends NSObject {
  
  public static var NSAnyType:Number = 0; // Any value is allowed.
  public static var NSIntType:Number = 1; // Must be between INT_MIN and INT_MAX.
  public static var NSPositiveIntType:Number = 2; // Must be between 1 and INT_MAX.
  public static var NSFloatType:Number = 3; // Must be between –FLT_MAX and FLT_MAX.
  public static var NSPositiveFloatType:Number = 4; // Must be between FLT_MIN and FLT_MAX.
  public static var NSDoubleType:Number = 5; // Must be between –DBL_MAX and DBL_MAX.
  public static var NSPositiveDoubleType:Number = 6; // Must be between DBL_MAX and DBL_MAX.
  
  public static var NSOffState:Number = 0;
  public static var NSOnState:Number = 1;
  public static var NSMixedState:Number = -1;

  //******************************************************                               
  //*         Constants used by NSButtonCell
  //******************************************************
  
  //
  // These constants specify what happens when a button is pressed or is
  // displaying its alternate state.
  //
  /** The button cell doesn't change. */
  public static var NSNoCellMask:Number = 0;
  /** The button cell pushes in if it has a border. */
  public static var NSPushInCellMask:Number = 1;
  /** The button cell displays its alternate title and image. */
  public static var NSContentsCellMask:Number = 2;
  /** The button cell swaps the control color with white pixels. NOT SUPPORTED. */
  public static var NSChangeGrayCellMask:Number = 4;
  /** Same as NSChangeGrayCellMask, only the background pixels are swapped. */
  public static var NSChangeBackgroundCellMask:Number = 8;
  
  //******************************************************                               
  //*                 Member variables
  //******************************************************
  
  private var m_stringValue:Object;
  private var m_objectValue:Object;
  private var m_hasValidObjectValue:Boolean;
  
  private var m_image:NSImage;
  private var m_type:NSCellType;
  private var m_state:Number;
  private var m_allowsMixedState:Boolean;
  private var m_formatter:NSFormatter;
  private var m_font:NSFont;
  private var m_fontColor:NSColor;
  private var m_editable:Boolean;
  private var m_selectable:Boolean;
  private var m_scrollable:Boolean;
  private var m_alignment:NSTextAlignment;
  private var m_wraps:Boolean;
  private var m_cellAttributes:Array;
  private var m_enabled:Boolean;
  private var m_bezeled:Boolean;
  private var m_bordered:Boolean;
  private var m_actionMask:Number;
  private var m_refusesFirstResponder:Boolean;
  private var m_showsFirstResponder:Boolean;
  private var m_sendsActionOnEndEditing:Boolean;
  private var m_mouseDownFlags:Number;
  private var m_highlighted:Boolean;
  private var m_controlSize:NSControlSize;
  private var m_controlView:NSView;
  private var m_app:NSApplication;
  private var m_periodicInterval:Number;
  private var m_periodicDelay:Number;
  private var m_isTruncated:Boolean;
  private var m_lineBreakMode:NSLineBreakMode;
  private var m_representedObject:Object;
  
  // An AS method cannot block, so a callback is needed for tracking mouse events
  private var m_trackingCallback:Object;
  private var m_trackingCallbackSelector:String;
  private var m_trackingData:Object;
  
  //******************************************************                               
  //*                    Construction
  //******************************************************
  
  /**
   * Creates a new instance of <code>NSCell</code>.
   * 
   * This must be followed by an initialization method.
   */
  public function NSCell() {
    m_trackingData = null;
    m_stringValue = null;
    m_objectValue = null;
    m_hasValidObjectValue = false;
    m_type = NSCellType.NSNullCellType;
    m_state = NSOffState;
    m_allowsMixedState = false;
    m_editable = false;
    m_selectable = false;
    m_scrollable = false;
    m_alignment = NSTextAlignment.NSLeftTextAlignment;
    m_wraps = false;
    m_cellAttributes = new Array();
    m_enabled = true;
    m_bezeled = false;
    m_isTruncated = false;
    m_actionMask = 0;
    m_refusesFirstResponder = false;
    m_showsFirstResponder = false;
    m_sendsActionOnEndEditing = false;
    m_mouseDownFlags = 0;
    m_trackingData = null;
    m_controlSize = NSControlSize.NSRegularControlSize;
    m_lineBreakMode = NSLineBreakMode.NSDefaultLineBreak;
    m_controlView = null;
    m_app = NSApplication.sharedApplication();
  }
  
  /**
   * Initializes the cell as a text cell with an empty string.
   */
  public function init():NSCell {
    return initTextCell("");
  }
  
  /**
   * Initializes the cell as an image cell with an image of <code>image</code>.
   */
  public function initImageCell(image:NSImage):NSCell {
    m_type = NSCellType.NSImageCellType;
    m_image = image;
    m_font = NSFont.systemFontOfSize(0);
    m_fontColor = NSColor.systemFontColor();
    m_actionMask = NSEvent.NSLeftMouseUpMask;
    return this;
  }
  
  /**
   * Initializes a text cell with the text <code>text</code>.
   */
  public function initTextCell(text:String):NSCell {
    m_type = NSCellType.NSTextCellType;
    m_stringValue = text;
    m_font = NSFont.systemFontOfSize(0);
    m_fontColor = NSColor.systemFontColor();
    m_actionMask = NSEvent.NSLeftMouseUpMask;
    return this;
  }

  /*
   * Overridden by subclasses to clean up cell resources
   */
  public function release() {
    
  }
  
  //******************************************************                               
  //*         Setting and getting cell values
  //******************************************************
  
  /**
   * Returns whether the object associated with the cell has a valid object 
   * value.
   * 
   * A valid object value is one that the cell’s formatter can "understand". 
   * Objects are always assumed to be valid unless they are rejected by the 
   * formatter.
   */
  public function hasValidObjectValue():Boolean {
    return m_hasValidObjectValue;
  }

  /**
   * Sets the cell's object value to <code>value</code>.
   */
  public function setObjectValue(value:Object) {
    m_objectValue = value;
    var contents:String = m_formatter.stringForObjectValue(m_objectValue);
    if (contents == null) {
      if ((m_formatter == null) && (value instanceof String)) {
        contents = String(m_objectValue);
        m_hasValidObjectValue = true;
      } else {
        contents = m_objectValue.description();
        m_hasValidObjectValue = false;
      }
    } else {
      m_hasValidObjectValue = true;
    }
    m_stringValue = contents;
  }
  
  /**
   * Returns the cell's object value unless if it is valid, otherwise
   * <code>null</code>.
   */
  public function objectValue():Object {
    if (m_hasValidObjectValue) {
      return m_objectValue;
    } else {
      return null;
    }
  }
  
  /**
   * Sets the value of the cell to an object <code>value</code>, representing 
   * an integer value.
   */
  public function setIntValue(value:Number) {
    setObjectValue(NSNumber.numberWithInt(value));
  }
  
  /**
   * Returns the cell’s value as an int.
   */
  public function intValue():Number {
    if (m_objectValue != null && (typeof(m_objectValue["intValue"]) == "function")) {
      return m_objectValue.intValue();
    } else {
      return Number(stringValue());
    }
  }
  
  /**
   * Sets the value of the cell to an object <code>value</code>, representing 
   * a double value.
   */
  public function setDoubleValue(value:Number) {
    setObjectValue(NSNumber.numberWithDouble(value));
  }

  /**
   * Returns the cell’s value as a double.
   */
  public function doubleValue():Number {
    if (m_objectValue != null && (typeof(m_objectValue["doubleValue"]) == "function")) {
      return m_objectValue.doubleValue();
    } else {
      return Number(stringValue());
    }
  }

  /**
   * Sets the value of the cell to an object <code>value</code>, representing 
   * a float value.
   */
  public function setFloatValue(value:Number) {
    setObjectValue(NSNumber.numberWithFloat(value));
  }

  /**
   * Returns the cell’s value as a float.
   */
  public function floatValue():Number {
    if (m_objectValue != null && (typeof(m_objectValue["floatValue"]) == "function")) {
      return m_objectValue.floatValue();
    } else {
      return Number(stringValue());
    }
  }

  /**
   * Sets the value of the cell to an object <code>value</code>, representing 
   * a string value.
   * 
   * The default implementation invokes <code>#setObjectValue()</code>.
   */
  public function setStringValue(string:String) {
    if (m_type != NSCellType.NSTextCellType) {
      setType(NSCellType.NSTextCellType);
    }
    if (m_formatter == null) {
      m_stringValue = string;
      m_objectValue = null;
    } else {
      //! Set the value with a formatter
    }
  }

  /**
   * Returns the value of the cell as a string.
   */
  public function stringValue():String {
    if (m_stringValue instanceof NSAttributedString) {
      return NSAttributedString(m_stringValue).string();
    } else {
      return String(m_stringValue);
    }
  }
  
  //******************************************************                               
  //*         Setting and getting cell attributes
  //******************************************************
  
  /**
   * Sets a cell attribute identified by aParameter such as the receiver's
   * state and whether it's disabled, editable, or highlighted to value.
   */
  public function setCellAttributeTo(attribute:NSCellAttribute, to:Number) {
    m_cellAttributes[attribute.value] = to;
  }
  
  public function cellAttribute(attribute:NSCellAttribute):Number {
    return m_cellAttributes[attribute.value];
  }

  public function type():NSCellType {
    return m_type;
  }

  public function setType(value:NSCellType) {
    m_type = value;
  }
  
  public function setEnabled(value:Boolean) {
    m_enabled = value;
  }
  
  public function isEnabled():Boolean {
    return m_enabled;
  }
  
  /**
   * Sets whether the receiver draws itself with a bezeled border, depending
   * on the Boolean value flag. The setBezeled: and setBordered: methods are
   * mutually exclusive (that is, a border can be only plain or bezeled).
   * Invoking this method results in setBordered: being sent with a value of FALSE.
   */  
  public function setBezeled(value:Boolean) {
    m_bezeled = value;
    if (m_bezeled) {
      m_bordered = false;
    }
  }
  
  /**
   * Returns whether the receiver has a bezeled border.
   */
  public function isBezeled():Boolean {
    return m_bezeled;
  }

  /**
   * Sets whether the receiver draws itself outlined with a plain border,
   * depending on the Boolean value flag. The setBezeled: and setBordered:
   * methods are mutually exclusive (that is, a border can be only plain or
   * bezeled). Invoking this method results in setBezeled: being sent with a
   * value of FALSE.
   */
  public function setBordered(flag:Boolean) {
    m_bordered = flag;
    if (m_bordered) {
      m_bezeled = false;
    }
  }
  
  /**
   * Returns whether the receiver has a plain border.
   */
  public function isBordered():Boolean {
    return m_bordered;
  }
  
  /**
   * Returns whether the receiver is opaque (nontransparent).
   */
  public function isOpaque():Boolean {
    return false;
  }

  //! TODO - (BOOL)allowsUndo
  //! TODO - (void)setAllowsUndo:(BOOL)allowsUndo
  
  /**
   * For internal use.
   * 
   * Returns <code>true</code> if the text displayed by this cell has been
   * truncated.
   */
  public function isTruncated():Boolean {
    return m_isTruncated;
  }
  
  //******************************************************                               
  //*                Setting the state
  //******************************************************
  
  /**
   * Returns <code>true</code> if the cell allows three states:
   * on, off and mixed.
   */
  public function allowsMixedState():Boolean {
    return m_allowsMixedState;
  }
  
  /**
   * Returns the cell's next state.
   * 
   * If the cell has three states, it cycles through them in the order of
   * on, off, mixed, on, off, mixed and so on.
   */
  public function nextState():Number {
    switch(m_state) {
      case NSOnState:
        return NSOffState;
        break;
      case NSOffState:
        if(m_allowsMixedState) {
          return NSMixedState;
        } else {
          return NSOnState;
        }
        break;
      case NSMixedState:
        return NSOnState;
        break;
      default:
        return NSOnState;
        break;
    }
  }

  /**
   * If <code>value</code> is <code>true</code>, the cell will have three 
   * states, on, off and mixed. Otherwise it will only have on and off.
   */
  public function setAllowsMixedState(value:Boolean) {
    m_allowsMixedState = value;
  }
  
  /**
   * Sets the cell's state to its next state.
   * 
   * @see #nextState()
   */
  public function setNextState() {
    setState(nextState());
  }

  /**
   * Returns the cell's current state.
   */
  public function state():Number {
    return m_state;
  }

  /**
   * Sets the cell's state to <code>value</code>.
   * 
   * If <code>value</code> is <code>NSMixedState</code> and the cell does not
   * allow mixed state, this method sets the state to <code>NSOnState</code>.
   */
  public function setState(value:Number) {
    if (value == NSMixedState && !allowsMixedState()) {
      value = NSOnState;
    }
    m_state = value;
  }
  
  //******************************************************                               
  //*        Modifying textual attributes of cells
  //******************************************************
  
  /**
   * Sets whether this cell is editable to <code>value</code>.
   */
  public function setEditable(value:Boolean) {
    m_editable = value;
  }
  
  /**
   * Returns whether this cell is editable.
   */
  public function isEditable():Boolean {
    return m_editable;
  }

  /**
   * Sets whether this cell is selectable to <code>value</code>.
   */
  public function setSelectable(value:Boolean) {
    m_selectable = value;
    if (!m_selectable) {
      m_editable = false;
    }
  }
  
  /**
   * Returns whether this cell is selectable.
   */
  public function isSelectable():Boolean {
    return m_enabled && (m_selectable || m_editable);
  }
  
  /**
   * Sets whether this cell is scrollable to <code>value</code>.
   */
  public function setScrollable(value:Boolean) {
    m_scrollable = value;
  }
  
  /**
   * Returns whether this cell is scrollable.
   */
  public function isScrollable():Boolean {
    return m_scrollable;
  }
  
  /**
   * Sets this cell's text alignment to <code>value</code>.
   */
  public function setAlignment(value:NSTextAlignment) {
    m_alignment = value;
  }
  
  /**
   * Returns this cell's text alignment.
   * 
   * The default is <code>NSTextAlignment#NSLeftTextAlignment</code>.
   */
  public function alignment():NSTextAlignment {
    
    return m_alignment;
  }
  
  /**
   * Returns this cell's font.
   */
  public function font():NSFont {
    return m_font;
  }
  
  /**
   * Sets this cell's font to <code>value</code>.
   */
  public function setFont(value:NSFont) {
    m_font = value;
  }
  
  /**
   * Sets this cell's font color to <code>color</code>.
   */
  public function setFontColor(color:NSColor) {
    m_fontColor = color;
  }
  
  /**
   * Returns this cell's font color.
   */
  public function fontColor():NSColor {
    return m_fontColor;
  }
  
  /**
   * Sets whether the text in this cell wraps when it exceeds the frame of
   * the cell. If <code>value</code> is <code>true</code> then the cell is also
   * set to be non-scrollable.
   * 
   * When <code>value</code> is <code>true</code>, a truncating type can also
   * be specified using <code>#setTruncatingType()</code>.
   */
  public function setWraps(value:Boolean) {
    m_wraps = value;
    if (m_wraps) {
      m_scrollable = false;
    }
  }
  
  /**
   * 
   */
  public function wraps():Boolean {
    return m_wraps;
  }

  /**
   * Sets how this cell should truncate its text to <code>type</code>. If
   * <code>type</code> is <code>null</code>, no truncating will occur.
   */  
  public function setLineBreakMode(type:NSLineBreakMode):Void {
    m_lineBreakMode = type;
  }
  
  /**
   * Returns an object describing how this cell should truncate its text, or
   * <code>null</code> if no truncating will occur.
   */
  public function lineBreakMode():NSLineBreakMode {
    return m_lineBreakMode;
  }
  
  public function setAttributedStringValue(value:NSAttributedString) {
    if (m_formatter != null) {
      //! What do we do with the attributed string values and the formatter?
    }
    m_stringValue = value;
  }
  
  public function attributedStringValue():NSAttributedString {
    if (m_stringValue instanceof NSAttributedString) {
      return NSAttributedString(m_stringValue);
    }
    if (m_formatter != null) {
      //! generate NSAttributedString?
    }
    return (new NSAttributedString()).initWithString(String(m_stringValue));
  }
  
  /**
   * Returns the receiver's title. By default it returns the cell's string
   * value. Subclasses, such as NSButtonCell, may override this method to
   * return a different value.
   */
  public function title():String {
    return stringValue();
  }
  
  /**
   * Sets the title of the receiver to aString.
   */
  public function setTitle(aString:String) {
    setStringValue(aString);
  }
  
  //******************************************************                               
  //*           Setting the target and action
  //******************************************************
  
  /**
   * Sets the action of this cell to <code>selector</code>.
   * 
   * The action is the name of the method on the <code>#target</code> that will
   * be called when the cell's action is fired. The method should take a single
   * parameter; the reference to the sender.
   */
  public function setAction(selector:String) {
    var e:NSException = NSException.exceptionWithNameReasonUserInfo(
      "NSInternalInconsistencyException",
      "Must be overridden by subclasses.",
      null);
    trace(e);
    throw e;
  }
  
  /**
   * Returns the action of this cell.
   */
  public function action():String {
    return null;
  }
  
  /**
   * Sets the target of this cell to <code>object</code>.
   * 
   * The target's <code>#action</code> method is called whenever the cell's 
   * action message is triggered.
   */
  public function setTarget(object:Object) {
    var e:NSException = NSException.exceptionWithNameReasonUserInfo(
      "NSInternalInconsistencyException",
      "Must be overridden by subclasses.",
      null);
    trace(e);
    throw e;
  }
  
  /**
   * Returns this cell's target.
   */
  public function target():Object {
    return null;
  }
  
  /**
   * Sets whether the receiver continuously sends its action message to its
   * target while it tracks the mouse, depending on the Boolean value flag. In
   * practice, the continuous setting has meaning only for instances of
   * NSActionCell and its subclasses, which implement the target/action mechanism.
   * Some NSControl subclasses, notably NSMatrix, send a default action to a
   * default target when a cell doesn't provide a target or action.
   */
  public function setContinuous(value:Boolean) {
    if(value) {
      m_actionMask |= NSEvent.NSPeriodicMask;
    } else {
      m_actionMask &= ~NSEvent.NSPeriodicMask;
    }
  }
  
  /**
   * Returns whether the receiver sends its action message continuously on mouse down.
   */
  public function isContinuous():Boolean {
    return (m_actionMask & NSEvent.NSPeriodicMask)!=0;
  }
  
  public function sendActionOn(mask:Number):Number {
    var oldMask:Number = m_actionMask;
    m_actionMask = mask;
    return oldMask;
  }
  
  //******************************************************                               
  //*            Setting and getting an image
  //******************************************************
  
  public function setImage(value:NSImage) {
    if (type()!=NSCellType.NSImageCellType) {
      setType(NSCellType.NSImageCellType);
    }
    m_image = value;
  }
  
  public function image():NSImage {
    if (type()!=NSCellType.NSImageCellType) {
      return null;
    }
    return m_image;
  }
  
  //******************************************************                               
  //*                  Assigning a tag
  //******************************************************
  
  public function setTag(value:Number) {
    var e:NSException = NSException.exceptionWithNameReasonUserInfo(
      "NSInternalInconsistencyException",
      "Must be overridden by subclasses.",
      null);
    trace(e);
    throw e;
  }
  
  public function tag():Number {
    return -1;
  }

  //******************************************************                               
  //*           Formatting and validating data
  //******************************************************

  /**
   * Returns the formatter object (a kind of <code>NSFormatter</code>) 
   * associated with the cell.
   * 
   * This object is responsible for translating an object's onscreen (text)
   * representation back and forth between its object value.
   */
  public function formatter():NSFormatter {
    return m_formatter;
  }

  /**
   * Sets the formatter object used to format the textual representation of the 
   * cell’s object value and to validate cell input and convert it to that 
   * object value.
   */
  public function setFormatter(value:NSFormatter) {
    if (null == value.stringForObjectValue(objectValue())) {
      setStringValue(value.toString());
    }
    
    m_formatter = value;
  }
  
  //******************************************************
  //*            Managing menus for cells
  //******************************************************
  
  //! TODO + (NSMenu *)defaultMenu
  
  /**
   * Not implemented
   */
  public function menu():NSMenu {
    var e:NSException = NSException.exceptionWithNameReasonUserInfo(
      NSException.NSGeneric,
      "method not implemented",
      null);
    trace(e);
    throw e;
    
    //! TODO implement menu()
    
    return null;
  }
  
  /**
   * Not implemented
   */
  public function setMenu(aMenu:NSMenu):Void {
    var e:NSException = NSException.exceptionWithNameReasonUserInfo(
      NSException.NSGeneric,
      "method not implemented",
      null);
    trace(e);
    throw e;
    //! TODO implement setMenu()
  }
  
  //! TODO - (NSMenu *)menuForEvent:(NSEvent *)anEvent inRect:(NSRect)cellFrame ofView:(NSView *)aView
  
  //******************************************************
  //*                 Comparing cells
  //******************************************************
  
  /**
   * <p>Compares the string values of the cell and <code>otherObject</code> (which 
   * must be a kind of <code>NSCell</code>), disregarding case.</p>
   * 
   * <p>Raises exception if <code>otherObject</code> is not of the 
   * <code>NSCell</code> class.</p>
   */
  public function compare(otherObject:Object):NSComparisonResult {
    if (!(otherObject instanceof NSCell)) {
      var e:NSException = NSException.exceptionWithNameReasonUserInfo(
        NSException.NSBadComparisonException,
        "Cannot compare a cell with a non-cell.",
        null);
      trace(e);
      throw e;
    }
    
    var str1:String = stringValue().toLowerCase();
    var str2:String = NSCell(otherObject).stringValue().toLowerCase();
    
    if (str1 < str2) {
      return NSComparisonResult.NSOrderedAscending;
    }
    else if (str1 > str2) {
      return NSComparisonResult.NSOrderedDescending;
    }
    
    return NSComparisonResult.NSOrderedSame;
  }
  
  //******************************************************                               
  //*       Making cells respond to keyboard events
  //******************************************************
  
  public function acceptsFirstResponder():Boolean {
    return m_enabled && !m_refusesFirstResponder;
  }
  
  public function setRefusesFirstResponder(value:Boolean) {
    m_refusesFirstResponder = value;
  }
  
  public function refusesFirstResponder():Boolean {
    return m_refusesFirstResponder;
  }
  
  public function setShowsFirstResponder(value:Boolean) {
    m_showsFirstResponder = value;
  }
  
  //! TODO - (void)setTitleWithMnemonic:(NSString *)aString
  //! TODO - (NSString *)mnemonic
  //! TODO - (void)setMnemonicLocation:(unsigned)location
  
  public function showsFirstResponder():Boolean {
    return m_showsFirstResponder;
  }
  
  public function performClick() {
    var cview:NSView = controlView();
    if (cview != null) {
      performClickWithFrameInView(cview.bounds(), cview);
    }
  }
  
  public function performClickWithFrameInView(frame:NSRect, view:NSView) {
    if (!m_enabled) {
      return;
    }
    if(view != null) {
      setHighlighted(true);
      drawWithFrameInView(frame, view);
      NSTimer.scheduledTimerWithTimeIntervalTargetSelectorUserInfoRepeats(.1, this, "__performClickCallback", {frame:frame, view:view}, false);
    } else {
      setNextState();
      NSApplication.sharedApplication().sendActionToFrom(action(), target(), this);
    }
  }
  
  private function __performClickCallback(timer:NSTimer) {
    var info:Object = timer.userInfo();
    setHighlighted(false);
    drawWithFrameInView(info.frame, info.view);
    setNextState();
    NSControl(info.view).sendActionTo(action(), target());
  }
  
  //******************************************************                               
  //*         Deriving values from other cells
  //******************************************************
  
  public function takeObjectValueFrom(sender:Object) {
    setObjectValue(sender.objectValue());
  }
  
  public function takeIntValueFrom(sender:Object) {
    setIntValue(sender.intValue());
  }

  public function takeStringValueFrom(sender:Object) {
    setStringValue(sender.stringValue());
  }
  
  public function takeDoubleValueFrom(sender:Object) {
    setDoubleValue(sender.doubleValue());
  }
  
  public function takeFloatValueFrom(sender:Object) {
    setFloatValue(sender.floatValue());
  }
  
  //******************************************************
  //*         Representing an object with a cell
  //******************************************************
  
  /**
   * Sets the object represented by the cell to <code>anObject</code>.
   */
  public function setRepresentedObject(anObject:Object):Void {
    m_representedObject = anObject;
  }
  
  /**
   * Returns the object the cell represents.
   * 
   * For example, you could have a pop-up list of color names, and the 
   * represented objects could be the appropriate <code>NSColor</code> objects.
   */
  public function representedObject():Object {
    return m_representedObject;
  }
  
  //******************************************************                               
  //*                Tracking the mouse
  //******************************************************
  
  public function setTrackingCallbackSelector(callback:Object, selector:String) {
    m_trackingCallback = callback;
    m_trackingCallbackSelector = selector;
  }
  
  private function trackingEventMask():Number {
    return NSEvent.NSLeftMouseDownMask | NSEvent.NSLeftMouseUpMask | NSEvent.NSLeftMouseDraggedMask
      | NSEvent.NSMouseMovedMask  | NSEvent.NSOtherMouseDraggedMask | NSEvent.NSRightMouseDraggedMask;
  }
  
  public static function prefersTrackingUntilMouseUp():Boolean {
    return false;
  }
  
  /*
   * This method normally returns a boolean, but we have to support a callback
   * mechanism
   *
   * @see setTrackingCallbackSelector
   */
  public function trackMouseInRectOfViewUntilMouseUp(event:NSEvent, rect:NSRect, 
      view:NSView, untilMouseUp:Boolean):Void { 
    var location:NSPoint = event.mouseLocation;
    var point:NSPoint = location.clone();
    var periodic:Boolean = false;
      
    view.mcBounds().globalToLocal(point);
    if(!startTrackingAtInView(point, view)) {
      m_trackingCallback[m_trackingCallbackSelector].call(m_trackingCallback, 
        false);
      return;
    }
    if((m_actionMask & NSEvent.NSLeftMouseDownMask) 
        && event.type == NSEvent.NSLeftMouseDown) {
      NSControl(controlView()).sendActionTo(action(), target());
    }
    
    m_trackingData = { 
      location: location,
      untilMouseUp: untilMouseUp,
      action: action(),
      target: target(),
      view: view,
      lastPoint: point,
      eventMask: trackingEventMask()
    };
    
    if(m_actionMask & NSEvent.NSPeriodicMask) {
      var times:Object = getPeriodicDelayInterval();      
      NSEvent.startPeriodicEventsAfterDelayWithPeriod(times.delay, times.interval);
      m_trackingData.eventMask |= NSEvent.NSPeriodicMask;
      periodic = true;
    }
    
    //don't track if modal loop has started
    if(m_app.isRunningModal() && m_controlView.window()!=m_app.modalWindow()) {
      m_trackingCallback[m_trackingCallbackSelector].call(m_trackingCallback, 
        true, periodic);
      return;
    }
    
    m_app.callObjectSelectorWithNextEventMatchingMaskDequeue(this, 
      "mouseTrackingCallback", m_trackingData.eventMask, true);
  }
  
  public function mouseTrackingCallback(event:NSEvent):Void {
  	//trace("NSCell.mouseTrackingCallback(event)");
    var point:NSPoint = event.mouseLocation.clone();
    //optional cast -- apparently, mtasc's && returns last value
    var periodic:Boolean = Boolean((event.type == NSEvent.NSPeriodic) 
      && (m_actionMask & NSEvent.NSPeriodicMask));
    m_trackingData.view.mcBounds().globalToLocal(point);
    if(!m_trackingData.untilMouseUp
        && event.view != m_trackingData.view) { //moved out of view
      stopTrackingAtInViewMouseIsUp(m_trackingData.lastPoint, point, 
        controlView(), false);
      //stimulate mouseUp
      m_trackingCallback[m_trackingCallbackSelector].call(m_trackingCallback, 
        false, periodic);
      //
      // Stop sending periodic when mouse up **very impt**
      //
      if (m_actionMask & NSEvent.NSPeriodicMask) {  
        NSEvent.stopPeriodicEvents();
      }
    } else { // still in view
      if (event.type == NSEvent.NSLeftMouseUp) { // mouse up?
        stopTrackingAtInViewMouseIsUp(m_trackingData.lastPoint, point, 
          controlView(), true);
        m_trackingCallback[m_trackingCallbackSelector].call(m_trackingCallback, 
          true, periodic);

        setNextState();
        if(m_actionMask & NSEvent.NSLeftMouseUpMask) {
          m_trackingData.view.sendActionTo(m_trackingData.action, 
            m_trackingData.target);
        }
        
        //
        // Stop sending periodic when mouse up **very impt**
        //
        if (m_actionMask & NSEvent.NSPeriodicMask) {
          NSEvent.stopPeriodicEvents();
        }
      } else { // no mouse up
        if (periodic) { //! Dragged too?
          m_trackingData.view.sendActionTo(m_trackingData.action, 
            m_trackingData.target);
        }
        
        if (continueTrackingAtInView(m_trackingData.lastPoint, point, 
            controlView())) {
          m_trackingData.lastPoint = point;
          m_trackingCallback[m_trackingCallbackSelector].call(
            m_trackingCallback, false, periodic);
              
          m_app.callObjectSelectorWithNextEventMatchingMaskDequeue(this, 
            "mouseTrackingCallback", m_trackingData.eventMask, true);
        } else { // don't continue...no mouse up
          stopTrackingAtInViewMouseIsUp(m_trackingData.lastPoint, point, 
            controlView(), false);
          m_trackingCallback[m_trackingCallbackSelector].call(
            m_trackingCallback, false, periodic);
              
          if (m_actionMask & NSEvent.NSPeriodicMask) {
            NSEvent.stopPeriodicEvents();
          }
        }
      }
    }
  }

  /**
   * Returns an object with delay and interval properties
   */
  public function getPeriodicDelayInterval():Object {
    return {delay:.1, interval:.1};
  }
  
  public function startTrackingAtInView(startPoint:NSPoint, 
    controlView:NSView):Boolean {
    return true;
  }
  
  public function continueTrackingAtInView(lastPoint:NSPoint, currentPoint:NSPoint, 
    controlView:NSView):Boolean {
    return true;
  }
  
  public function stopTrackingAtInViewMouseIsUp(lastPoint:NSPoint, stopPoint:NSPoint,
    controlView:NSView, mouseIsUp:Boolean) {
    //if mouseUp, this would have been done by control
    if(!mouseIsUp)  setHighlighted(false);
  }
  
  public function mouseDownFlags():Number {
    return m_mouseDownFlags;
  }
  
  //******************************************************
  //*            Handling keyboard alternatives
  //******************************************************
  
  /**
   * Implemented by subclasses to return a key equivalent to clicking the cell.
   * 
   * The default implementation returns an empty string.
   */
  public function keyEquivalent():String {
    return "";
  }
  
  //******************************************************                               
  //*               Determining cell sizes          
  //******************************************************
  
  public function cellSize():NSSize {
    var borderSize:NSSize;
    var csize:NSSize;
    if (m_bordered) {
      borderSize = NSBorderType.NSLineBorder.size;
    } else if(m_bezeled) {
      borderSize = NSBorderType.NSBezelBorder.size;;
    } else {
      borderSize = NSSize.ZeroSize;
    }
    switch(m_type.value) {
      case NSCellType.NSTextCellType.value:
        var text:NSAttributedString = attributedStringValue();
        if (text.string() == null || text.string().length == 0) {
          csize = font().getTextExtent("M");
        } else {
          csize = font().getTextExtent(String(text));
        }
        break;
      case NSCellType.NSImageCellType.value:
        if (m_image == null) {
          csize = NSSize.ZeroSize;
        } else {
          csize = m_image.size();
        }
        break;
      case NSCellType.NSNullCellType.value:
        csize = NSSize.ZeroSize;
        break;
    }
    
    csize.width += (borderSize.width * 2);
    csize.height += (borderSize.height * 2);
    return csize;
  }
  
  public function cellSizeForBounds(rect:NSRect):NSSize {
    if (m_type == NSCellType.NSTextCellType) {
      //! TODO Resize text to fit into supplied rect
    }
    return cellSize();
  }
  
  public function drawingRectForBounds(rect:NSRect):NSRect {
    var borderSize:NSSize;
    if (m_bordered) {
      borderSize = NSBorderType.NSLineBorder.size;
    } else if(m_bezeled) {
      borderSize = NSBorderType.NSBezelBorder.size;;
    } else {
      borderSize = NSSize.ZeroSize;
    }
    return rect.insetRect(borderSize.width, borderSize.height);
  }
  
  public function imageRectForBounds(rect:NSRect):NSRect {
    return drawingRectForBounds(rect);
  }
  
  public function titleRectForBounds(rect:NSRect):NSRect {
    if (m_type == NSCellType.NSTextCellType) {
      var frame:NSRect = drawingRectForBounds(rect);
      if (m_bordered || m_bezeled) {
        return frame.insetRect(3,1);
      }
    } else {
      return rect.clone();
    }
  }
  
  /**
   * Changing the cell’s control size does not change the font of the cell.
   * Use the {@link NSFont} class method 
   * {@link NSFont#systemFontSizeForControlSize} to obtain the system font based
   * on the new control size and set it.
   */
  public function setControlSize(csize:NSControlSize) {
    //! TODO Change font?
    m_controlSize = csize;
  }
  
  public function controlSize():NSControlSize {
    return m_controlSize;
  }

  //******************************************************                               
  //*          Drawing and highlighting cells
  //******************************************************
  
  /**
   * Draws the receiver’s regular or bezeled border (if those attributes are 
   * set) and then draws the interior of the cell by invoking 
   * {@link #drawInteriorWithFrameInView()}.
   * 
   * @see #drawInteriorWithFrameInView()
   */
  public function drawWithFrameInView(cellFrame:NSRect, inView:NSView) {
    if (cellFrame.isEmptyRect() || inView.window()==null) {
      return;
    }
    var x:Number = cellFrame.origin.x;
    var y:Number = cellFrame.origin.y;
    var width:Number = cellFrame.size.width;
    var height:Number = cellFrame.size.height;
    var mc:MovieClip = inView.mcBounds();
    if(m_bordered) {
      ASDraw.drawRectWithRect(mc, cellFrame, 0x696E79);
    } else if (m_bezeled) {
      ASDraw.outlineRectWithRect(mc, cellFrame,
        [
          0xF6F8F9,
          0x696E79,
          0x696E79,
          0xF6F8F9
        ], [100, 100, 100, 100]);
    }
    drawInteriorWithFrameInView(cellFrame, inView);
  }

  /**
   * <p>Draws the “inside” of the receiver—including the image or text within the 
   * receiver’s frame in <code>controlView</code> (usually the cell’s 
   * {@link NSControl}) but excluding the border.</p>
   * 
   * <p><code>cellFrame</code> is the frame of the <code>NSCell</code> or, in 
   * some cases, a portion of it. Text-type <code>NSCell</code>s display their 
   * contents in a rectangle slightly inset from <code>cellFrame</code>. 
   * Image-type <code>NSCell</code>s display their contents centered within 
   * <code>cellFrame</code>. If the proper attributes are set, it also displays 
   * the colored rectangle to indicate first responder and highlights the cell. 
   * This method is invoked from <code>NSControl</code>’s 
   * {@link NSControl#drawCellInside()} to visually update what the 
   * <code>NSCell</code> displays when its contents change. This drawing is 
   * minimal and becomes more complex in objects such as 
   * {@link org.actionstep.NSButtonCell} and 
   * {@link org.actionstep.NSSliderCell}.</p>
   * 
   * <p>Subclasses often override this method to provide more sophisticated 
   * drawing of cell contents. Because {@link #drawWithFrameInView} invokes 
   * {@link #drawInteriorWithFrameInView} after it draws the 
   * <code>NSCell</code>’s border, don’t invoke {@link #drawWithFrameInView} in 
   * your override implementation.</p>
   * 
   * @see #isHighlighted()
   * @see #showsFirstResponder()
   */
  public function drawInteriorWithFrameInView(cellFrame:NSRect, inView:NSView) {
    if (inView.window() == null) {
      return;
    }
    cellFrame = drawingRectForBounds(cellFrame);
    if (m_bordered || m_bezeled) { // inset a bit more
      cellFrame = cellFrame.insetRect(3,1);
    }
    if(m_type == NSCellType.NSTextCellType) {
      //! draw attributedStringValue();
    } else if (m_type == NSCellType.NSImageCellType) {
      var size:NSSize = m_image.size();
      var position:NSPoint = new NSPoint(cellFrame.midX() - (size.width/2), cellFrame.midY() - (size.height/2));
      if (position.x < 0) {
        position.x = 0;
      }
      if (position.y < 0) {
        position.y = 0;
      }
      m_image.lockFocus(inView.mcBounds());
      m_image.drawAtPoint(position);
      m_image.unlockFocus();
    }
  }

  /**
   * <p>Sets the receiver’s control view.</p>
   * 
   * <p>The control view represents the control currently being rendered by the 
   * cell.</p>
   * 
   * @see #controlView()
   */  
  public function setControlView(view:NSView) {
    m_controlView = view;
  }

  /**
   * Implemented by subclasses to return the <code>NSView</code> last drawn in 
   * (normally an {@link NSControl}).
   */
  public function controlView():NSView {
    return m_controlView;
  }
  
  /**
   * If the receiver’s highlight status is different from <code>flag</code>, 
   * sets that status to <code>flag</code> and, if <code>flag</code> is 
   * <code>true</code>, highlights the rectangle <code>cellFrame</code> in the 
   * {@link NSControl} (<code>controlView</code>).
   * 
   * @see #isHighlighted()
   * @see #drawWithFrameInView()
   */
  public function highlightWithFrameInView(flag:Boolean, cellFrame:NSRect, controlView:NSView) {
    if (isHighlighted() != flag) {
      setHighlighted(flag);
    }
    drawWithFrameInView(cellFrame, controlView);
  }
  
  /**
   * <p>Sets whether the receiver has a highlighted appearance, depending on the 
   * Boolean value <code>flag</code>.</p>
   */
  public function setHighlighted(value:Boolean) {
    m_highlighted = value;
  }
  
  /**
   * Returns whether the receiver is highlighted.
   */
  public function isHighlighted():Boolean {
    return m_highlighted;
  }
  
  //******************************************************                               
  //*           Editing and selecting cell text
  //******************************************************
  
  /**
   * Begins editing of the cell’s text using the field editor 
   * <code>editor</code>.
   * 
   * This method is usually invoked in response to a mouse-down event. theEvent 
   * is the <code>NSLeftMouseDown</code> event. <code>anObject</code> is made 
   * the delegate of <code>editor</code> and so will receive various delegation 
   * and notification messages.
   * 
   * If the cell isn’t a text-type <code>NSCell</code>, no editing is performed.
   * 
   * This is ActionStep's version of 
   * <code>#editWithFrameInViewEditorDelegateEvent</code>.
   */
  public function editWithEditorDelegateEvent(editor:ASFieldEditor, 
      anObject:Object, event:NSEvent):Void {
    //
    // Don't do anything on non text type.
    //
    if (type() != NSCellType.NSTextCellType || editor == null) {
      return;
    }
    
    editor.startInstanceEdit(this, anObject, textField());
  }
  
  /**
   * Uses the field editor <code>editor</code> to select text in a range marked 
   * by <code>start</code> and <code>length</code>, which will be highlighted 
   * and selected as though the user had dragged the cursor over it.
   * 
   * This is ActionStep's version of 
   * <code>#selectWithFrameInViewEditorDelegateStartLength</code>.
   */
  public function selectWithEditorDelegateStartLength(editor:ASFieldEditor, 
      anObject:Object, start:Number, length:Number):Void {
    //
    // Don't do anything on non text type.
    //
    if (type() != NSCellType.NSTextCellType || editor == null) {
      return;
    }
    
    editor.startInstanceEdit(this, anObject, textField());
    editor.setSelectedRange(new NSRange(start, length));
  }
  
  /**
   * Ends any editing of text, using the field editor <code>editor</code>.
   */
  public function endEditing(editor:ASFieldEditor):Void {
    if (editor.cell() != this) {
      return;
    }
    
    editor.endInstanceEdit();
  }
  
  /**
   * Sets whether the cell’s <code>NSControl</code> object sends its action 
   * message whenever the user finishes editing the cell’s text.
   * 
   * If <code>flag</code> is <code>true</code>, the cell’s 
   * <code>NSControl</code> object sends its action message when the user does 
   * one of the following:
   *   - Presses the Return key
   *   - Presses the Tab key to move out of the field
   *   - Clicks another text field
   *   
   * If <code>flag</code> is <code>false</code>, the cell’s 
   * <code>NSControl</code> object sends its action message only when the user 
   * presses the Return key.
   */
  public function setSendsActionOnEndEditing(value:Boolean) {
    m_sendsActionOnEndEditing = value;
  }
  
  /**
   * Returns whether the cell’s <code>NSControl</code> object sends its action 
   * message whenever the user finishes editing the cell’s text.
   * 
   * If it returns <code>true</code>, the cell’s <code>NSControl</code> object 
   * sends its action message when the user does one of the following:
   *   - Presses the Return key
   *   - Presses the Tab key to move out of the field
   *   - Clicks another text field
   *   
   * If it returns <code>false</code>, the cell’s <code>NSControl</code> object 
   * sends its action message only when the user presses the Return key.
   */
  public function sendsActionOnEndEditing():Boolean {
    return m_sendsActionOnEndEditing;
  }
  
  //******************************************************
  //*          Text editing related methods
  //******************************************************
  
  /**
   * To be overridden in subclasses that support text editing.
   */
  private function textField():TextField {
    var e:NSException = NSException.exceptionWithNameReasonUserInfo(
      "NSAbstractMethodException",
      "textField() should be implemented in subclasses.",
      null);
    trace(e);
    throw e;
    return null;
  }
  
  //******************************************************                               
  //*             Describing the object
  //******************************************************
  
  /**
   * Returns a string representation of the cell.
   */
  public function description():String {
    return "NSCell()";
  }
  
  //******************************************************                               
  //*           Helper methods for truncation
  //******************************************************

  /**
   * Returns <code>str</code> truncated to fit within <code>width</code>
   * with a leading ellipsis.
   */
  private function truncateTextWithMiddleEllipsis(str:String, width:Number)
      :String {
    if (m_font.getTextExtent(str).width < width) {
      return str;
    }
    var range:NSRange = findMiddleEllipsisRange(str, width);
    return str.substring(0, range.location) + "..." +
      str.substr(range.location + range.length);
  }
  
  /**
   * Returns <code>str</code> truncated to fit within <code>width</code>
   * with a leading ellipsis.
   */
  private function truncateTextWithTrailingEllipsis(str:String, width:Number)
      :String {
    if (m_font.getTextExtent(str).width < width) {
      return str;
    }
    var ellipsisPos:Number = findTrailingEllipsisPosition(str, width);
    return str.substring(0, ellipsisPos) + "...";
  }
    
  /**
   * Returns <code>str</code> truncated to fit within <code>width</code>
   * with a leading ellipsis.
   */
  private function truncateTextWithLeadingEllipsis(str:String, width:Number)
      :String {    
    if (m_font.getTextExtent(str).width < width) {
      return str;
    }
    var ellipsisPos:Number = findLeadingEllipsisPosition(str, width);
    return "..." + str.substr(ellipsisPos);
  }
  
  /**
   * Returns a number representing the index from which all characters in
   * <code>str</code> will be replaced with an ellipsis so that the string
   * will fit within <code>width</code> for the cell's current font.
   */
  private function findTrailingEllipsisPosition(str:String, width:Number):Number {
    if (m_font.getTextExtent("...").width > width) {
      return 0;
    }
    
    var midPoint:Number = Math.round(str.length / 2);
    var range:Number = midPoint;
    var lengthToChar:Number = m_font.getTextExtent(str.substring(0, midPoint) 
      + "...").width;
    var eleSet:NSArray = NSArray.array();

    while (true) {
      range = Math.round(range / 2);

      if (width > lengthToChar)  {
        midPoint = midPoint + range;
      }
      else if (width < lengthToChar) {
        midPoint = midPoint - range;
      } else {
        return midPoint;
      }

      lengthToChar = m_font.getTextExtent(str.substring(0, midPoint) + "...").width;

      if ((width - lengthToChar <= 2 && width - lengthToChar >= 0)
          || eleSet.containsObject(midPoint)) {
        return midPoint;
      }

      if (lengthToChar < width) {
        eleSet.addObject(midPoint);
      }
    }
  }

  /**
   * Returns a number representing the ending index that will replace the
   * characters in <code>str</code> from position 0 to the ending index with
   * an ellipsis so that the string will fit within <code>width</code> with 
   * the current font.
   */
  private function findLeadingEllipsisPosition(str:String, width:Number):Number {
    if (m_font.getTextExtent("...").width > width) {
      return str.length - 1;
    }
    var midPoint:Number = Math.round(str.length / 2);
    var range:Number = midPoint;
    var lengthToChar:Number = m_font.getTextExtent("..." 
      + str.substr(midPoint)).width;
    var eleSet:NSArray = NSArray.array();

    while (true) {
      range = Math.round(range / 2);

      if (width > lengthToChar) {
        midPoint = midPoint - range;
      }
      else if (width < lengthToChar) {
        midPoint = midPoint + range;
      } else {
        return midPoint;
      }

      lengthToChar = m_font.getTextExtent("..." + str.substr(midPoint)).width;

      if ((width - lengthToChar <= 2 && width - lengthToChar >= 0) ||
          eleSet.containsObject(midPoint)) {
        return midPoint;
      }

      if (lengthToChar < width) {
         eleSet.addObject(midPoint);
      }
    }
  }

  /**
   * Returns a range representing the characters in <code>str</code> that 
   * will be replaced by an ellipsis when constrained to a width of 
   * <code>width</code> using the cell's current font.
   */
  private function findMiddleEllipsisRange(str:String, width:Number):NSRange {
    if (m_font.getTextExtent("...").width > width) {
      return new NSRange(0, str.length);
    }
    var midPoint:Number = Math.round(str.length / 2);
    var start:Number = midPoint;
    var end:Number = midPoint;

    while (true) {
      start--;

      var lengthToChar:Number = m_font.getTextExtent(str.substring(0, start) 
        + "..." + str.substr(end)).width;

      if (lengthToChar < width) {
        return new NSRange(start, end - start);
      }

      end++;

      lengthToChar = m_font.getTextExtent(str.substring(0, start) 
        + "..." + str.substr(end)).width;

      if (lengthToChar < width) {
        return new NSRange(start, end - start);
      }        
    }
  }

}
  