/* See LICENSE for copyright and terms of use */

import org.actionstep.constants.NSInterfaceStyle;
import org.actionstep.NSArray;
import org.actionstep.NSBeep;
import org.actionstep.NSEvent;
import org.actionstep.NSMenu;
import org.actionstep.NSObject;
import org.actionstep.NSUndoManager;

class org.actionstep.NSResponder extends NSObject {
  
  private var m_nextResponder:NSResponder;
  private var m_menu:NSMenu;
  private var m_interfaceStyle:NSInterfaceStyle;
  
  private function beep():Void {
    NSBeep.beep();
  }
  
  //******************************************************															 
  //*           Changing the first responder
  //******************************************************
  
  /**
   * <p>Overridden by subclasses to return <code>true</code> if the receiver can 
   * handle key events and action messages sent up the responder chain.</p>
   * 
   * <p>NSResponder’s implementation returns <code>false</code>, indicating that 
   * by default a responder object doesn’t agree to become first responder. 
   * Objects that aren’t first responder can receive mouse-down messages, but 
   * no other event or action messages.</p>
   * 
   * @see #becameFirstResponder()
   * @see #resignFirstResponder()
   */
  public function acceptsFirstResponder():Boolean {
    return false;
  }
  
  /**
   * <p>Notifies the receiver that it’s about to become first responder in its 
   * <code>NSWindow</code>.</p>
   * 
   * <p>NSResponder’s implementation returns <code>true</code>, accepting first 
   * responder status. Subclasses can override this method to update state or 
   * perform some action such as highlighting the selection, or to return 
   * <code>false</code>, refusing first responder status.</p>
   * 
   * <p>Use NSWindow’s {@link org.actionstep.NSWindow#makeFirstResponder()}, not 
   * this method, to make an object the first responder. Never invoke this 
   * method directly.</p>
   * 
   * @see #acceptsFirstResponder()
   * @see #resignFirstResponder()
   */
  public function becomeFirstResponder():Boolean {
    return true;
  }
  
  /**
   * Notifies the receiver that it’s been asked to relinquish its status as 
   * first responder in its <code>NSWindow</code>.
   * 
   * <p>NSResponder’s implementation returns <code>true</code>, resigning first 
   * responder status. Subclasses can override this method to update state or 
   * perform some action such as unhighlighting the selection, or to return 
   * <code>false</code>, refusing to relinquish first responder status.</p>
   * 
   * @see #acceptsFirstResponder()
   * @see #becomeFirstResponder()
   */
  public function resignFirstResponder():Boolean {
    return true;
  }
  
  //******************************************************															 
  //*            Setting the next responder
  //******************************************************

  /**
   * Sets the receiver’s next responder to <code>responder</code>.
   * 
   * @see #nextResponder()
   */
  public function setNextResponder(responder:NSResponder):Void {
    m_nextResponder = responder;
  }
  
  /**
   * Returns the receiver’s next responder, or <code>null</code> if it has none.
   * 
   * @see #setNextResponder()
   * @see #noResponderFor()
   */
  public function nextResponder():NSResponder {
    return m_nextResponder;
  }
  
  //******************************************************															 
  //*                 Event methods
  //******************************************************

  /**
   * <p>Informs the receiver that the user has pressed the left mouse button 
   * specified by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function mouseDown(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.mouseDown(event);
    } else {
      noResponderFor("mouseDown");
    }
  }
  
  /**
   * <p>Informs the receiver that the user has moved the mouse with the left 
   * button pressed specified by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function mouseDragged(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.mouseDragged(event);
    } else {
      noResponderFor("mouseDragged");
    }
  }
  
  /**
   * <p>Informs the receiver that the user has released the left mouse button 
   * specified by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function mouseUp(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.mouseUp(event);
    } else {
      noResponderFor("mouseUp");
    }
  }
  
  /**
   * <p>Informs the receiver that the mouse has moved specified by 
   * <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function mouseMoved(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.mouseMoved(event);
    } else {
      noResponderFor("mouseMoved");
    }
  }
  
  /**
   * <p>Informs the receiver that the cursor has entered a tracking rectangle 
   * specified by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function mouseEntered(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.mouseEntered(event);
    } else {
      noResponderFor("mouseEntered");
    }
  }
  
  /**
   * <p>Informs the receiver that the cursor has exited a tracking rectangle.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function mouseExited(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.mouseExited(event);
    } else {
      noResponderFor("mouseExited");
    }
  }
  
  /**
   * <p>Informs the receiver that the user has pressed the right mouse button 
   * specified by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function rightMouseDown(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.rightMouseDown(event);
    } else {
      noResponderFor("rightMouseDown");
    }
  }
  
  /**
   * <p>Informs the receiver that the user has moved the mouse with the right 
   * button pressed specified by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function rightMouseDragged(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.rightMouseDragged(event);
    } else {
      noResponderFor("rightMouseDragged");
    }
  }
  
  /**
   * <p>Informs the receiver that the user has released the right mouse button 
   * specified by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function rightMouseUp(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.rightMouseUp(event);
    } else {
      noResponderFor("rightMouseUp");
    }
  }
  
  /**
   * <p>Informs the receiver that the user has pressed a mouse button other 
   * than left or right specified by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function otherMouseDown(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.otherMouseDown(event);
    } else {
      noResponderFor("otherMouseDown");
    }
  }
  
  /**
   * <p>Informs the receiver that the user has moved the mouse with a button 
   * other than the left or right button pressed specified by 
   * <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function otherMouseDragged(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.otherMouseDragged(event);
    } else {
      noResponderFor("otherMouseDragged");
    }
  }
  
  /**
   * <p>Informs the receiver that the user has released a mouse button other 
   * than the left or right specified by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function otherMouseUp(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.otherMouseUp(event);
    } else {
      noResponderFor("otherMouseUp");
    }
  }
  
  /**
   * <p>Informs the receiver that the mouse’s scroll wheel has moved specified 
   * by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function scrollWheel(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.scrollWheel(event);
    } else {
      noResponderFor("scrollWheel");
    }
  }
  
  /**
   * <p>Informs the receiver that the user has pressed a key.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function keyDown(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.keyDown(event);
    } else {
      noResponderFor("keyDown");
    }
  }
  
  /**
   * <p>Informs the receiver that the user has released a key event specified 
   * by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function keyUp(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.keyUp(event);
    } else {
      noResponderFor("keyUp");
    }
  }
  
  /**
   * <p>Informs the receiver that the user has pressed or released a modifier 
   * key (Shift, Control, and so on) specified by <code>event</code>.</p>
   * 
   * <p>NSResponder’s implementation simply passes this message to the next 
   * responder.</p>
   */
  public function flagsChanged(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.flagsChanged(event);
    } else {
      noResponderFor("flagsChanged");
    }
  }
  
  /**
   * <p>Displays context-sensitive help for the receiver if such exists; 
   * otherwise passes this message to the next responder.</p>
   * 
   * <p>NSWindow invokes this method automatically when the user clicks for 
   * help—while processing <code>event</code>. Subclasses need not override 
   * this method, and application code shouldn’t directly invoke it.</p>
   * 
   * @see #showContextHelp()
   */
  public function helpRequested(event:NSEvent):Void {
    if(m_nextResponder!=undefined) {
      m_nextResponder.helpRequested(event);
    } else {
      noResponderFor("helpRequested");
    }
  }
  
  //******************************************************															 
  //*            Special key event methods
  //******************************************************
  
  /**
   * <p>Invoked to handle a series of key events contained by
   * <code>eventArray</code>.</p>
   * 
   * //! TODO Decide what this should do.
   */
  public function interpretKeyEvents(eventArray:NSArray):Void {
  }
  
  /**
   * <p>Overridden by subclasses to perform a key equivalent. If the character
   * code or codes in <code>event</code> match the responder's key equivalent,
   * the responder should respond to the event and return <code>true</code>.</p>
   * 
   * <p>The default implementation always returns <code>false</code>.</p>
   */
  public function performKeyEquivalent(event:NSEvent):Boolean {
    return false;
  }
  
  /**
   * <p>Overridden by subclasses to perform a mneumonic. If the character code
   * or codes in <code>string</code> match the responder's mneumonic, the 
   * responder should perform the mneumonic and return <code>true</code>.</p>
   * 
   * <p>The default implementation always returns <code>false</code>.</p>
   */
  public function performMneumonic(string:String):Boolean {
    return false;
  }
  
  //******************************************************															 
  //*              Clearing key events
  //******************************************************
  
  public function flushBufferedKeyEvent():Void { }
  
  //******************************************************															 
  //*                Action methods
  //******************************************************
  
  public function cancelOperation(sender:Object):Void { }
  public function capitalizeWord(sender:Object):Void { }
  public function centerSelectionInVisibleArea(sender:Object):Void { }
  public function changeCaseOfLetter(sender:Object):Void { }
  public function complete(sender:Object):Void { }
  public function deleteBackward(sender:Object):Void { }
  public function deleteBackwardByDecomposingPreviousCharacter(sender:Object):Void { }
  public function deleteForward(sender:Object):Void { }
  public function deleteToBeginningOfLine(sender:Object):Void { }
  public function deleteToBeginningOfParagraph(sender:Object):Void { }
  public function deleteToEndOfLine(sender:Object):Void { }
  public function deleteToEndOfParagraph(sender:Object):Void { }
  public function deleteToMark(sender:Object):Void { }
  public function deleteWordBackward(sender:Object):Void { }
  public function deleteWordForward(sender:Object):Void { }
  public function indent(sender:Object):Void { }
  public function insertBacktab(sender:Object):Void { }
  public function insertNewline(sender:Object):Void { }
  public function insertNewlineIgnoringFieldEditor(sender:Object):Void { }
  public function insertParagraphSeparator(sender:Object):Void { }
  public function insertTab(sender:Object):Void { }
  public function insertTabIgnoringFieldEditor(sender:Object):Void { }
  public function insertText(sender:Object):Void { 
    if (m_nextResponder != undefined) {
      m_nextResponder.insertText(sender);
    }
    else { 
      beep(); 
    }
  }
  public function lowercaseWord(sender:Object):Void { }
  public function moveBackward(sender:Object):Void { }
  public function moveBackwardAndModifySelection(sender:Object):Void { }
  public function moveDown(sender:Object):Void { }
  public function moveDownAndModifySelection(sender:Object):Void { }
  public function moveForward(sender:Object):Void { }
  public function moveForwardAndModifySelection(sender:Object):Void { }
  public function moveLeft(sender:Object):Void { }
  public function moveLeftAndModifySelection(sender:Object):Void { }
  public function moveRight(sender:Object):Void { }
  public function moveRightAndModifySelection(sender:Object):Void { }
  public function moveToBeginningOfDocument(sender:Object):Void { }
  public function moveToBeginningOfLine(sender:Object):Void { }
  public function moveToBeginningOfParagraph(sender:Object):Void { }
  public function moveToEndOfDocument(sender:Object):Void { }
  public function moveToEndOfLine(sender:Object):Void { }
  public function moveToEndOfParagraph(sender:Object):Void { }
  public function moveUp(sender:Object):Void { }
  public function moveUpAndModifySelection(sender:Object):Void { }
  public function moveWordBackward(sender:Object):Void { }
  public function moveWordBackwardAndModifySelection(sender:Object):Void { }
  public function moveWordForward(sender:Object):Void { }
  public function moveWordForwardAndModifySelection(sender:Object):Void { }
  public function moveWordLeft(sender:Object):Void { }
  public function moveWordRight(sender:Object):Void { }
  public function moveWordRightAndModifySelection(sender:Object):Void { }
  public function moveWordLeftAndModifySelection(sender:Object):Void { }
  public function pageDown(sender:Object):Void { }
  public function pageUp(sender:Object):Void { }
  public function scrollLineDown(sender:Object):Void { }
  public function scrollLineUp(sender:Object):Void { }
  public function scrollPageDown(sender:Object):Void { }
  public function scrollPageUp(sender:Object):Void { }
  public function selectAll(sender:Object):Void { }
  public function selectLine(sender:Object):Void { }
  public function selectParagraph(sender:Object):Void { }
  public function selectToMark(sender:Object):Void { }
  public function selectWord(sender:Object):Void { }
  public function setMark(sender:Object):Void { }
  public function showContextHelp(sender:Object):Void { }
  public function swapWithMark(sender:Object):Void { }
  public function transpose(sender:Object):Void { }
  public function transposeWords(sender:Object):Void { }
  public function uppercaseWord(sender:Object):Void { }
  public function yank(sender:Object):Void { }
  
  //******************************************************															 
  //*                Dispatch methods
  //******************************************************
  
  public function doCommandBySelector(selector:String):Void {
    var result:Boolean = tryToPerformWith(selector, null);
    if (!result) {
      beep();
    }
  }
  
  public function tryToPerformWith(selector:String, anObject:Object):Boolean {
    if(typeof(this[selector]) == "function") {
      this[selector].call(this, anObject);
      return true;
    } else {
      if(m_nextResponder!=undefined) {
        return m_nextResponder.tryToPerformWith(selector, anObject);
      } else {
        return false;
      }
    }
  }
  
  //******************************************************															 
  //*         Terminating the responder chain
  //******************************************************
  
  public function noResponderFor(selector:String):Void {
    if(selector=="keyDown") {
      beep();
    }
  }
  
  //******************************************************															 
  //*                Setting the menu
  //******************************************************
  
  public function setMenu(menu:NSMenu):Void {
    m_menu = menu;
  }
  
  public function menu():NSMenu {
    return m_menu;
  }
  
  //******************************************************															 
  //*           Setting the interface style
  //******************************************************
  
  public function setInterfaceStyle(style:NSInterfaceStyle):Void {
    m_interfaceStyle = style;
  }
  
  public function interfaceStyle():NSInterfaceStyle {
    return m_interfaceStyle;
  }
  
  //******************************************************															 
  //*                Undo manager
  //******************************************************
  
  public function undoManager():NSUndoManager {
    if(m_nextResponder!=undefined) {
      return m_nextResponder.undoManager();
    }
    return null;
  }
}