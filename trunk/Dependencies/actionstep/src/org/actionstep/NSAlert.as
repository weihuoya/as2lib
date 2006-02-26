/* See LICENSE for copyright and terms of use */

import org.actionstep.alert.ASAlertPanel;
import org.actionstep.constants.NSAlertReturn;
import org.actionstep.constants.NSAlertStyle;
import org.actionstep.NSApplication;
import org.actionstep.NSArray;
import org.actionstep.NSButton;
import org.actionstep.NSEvent;
import org.actionstep.NSObject;
import org.actionstep.NSRect;
import org.actionstep.NSWindow;
import org.actionstep.NSView;

/**
 * NSAlert displays a modal window to the user, and can contain text and icons.
 * The window displays a collection of buttons for the user to press. The alert
 * is dismissed after a button press has occurred.
 *
 * For an example of this class' usage, please see
 * <code>org.actionstep.test.ASTestSheet</code> or
 * <code>org.actionstep.test.ASTestPanel</code>.
 *
 * @author Tay Ray Chuan
 */
class org.actionstep.NSAlert extends NSObject {
	private var m_buttons:NSArray;
	private var m_style:NSAlertStyle;
	private var m_msg:String;
	private var m_info:String;
	private var m_showsHelp:Boolean;
	private var m_helpAnchor:String;
	private var m_delegate:Object;
	private var m_app:NSApplication;
	private var m_sheet:ASAlertPanel;

	public static function alertWithMessageTextDefaultButtonAlternateButtonOtherButton(
	    messageTitle:String, defaultButtonTitle:String,
	    alternateButtonTitle:String, otherButtonTitle:String):NSAlert {
	  var alert:NSAlert = new NSAlert();

	  alert.setMessageText(messageTitle);

	  if (defaultButtonTitle != null) {
			alert.addButtonWithTitle(defaultButtonTitle);
		} else {
			alert.addButtonWithTitle("OK");
		}

	  if (alternateButtonTitle != null) {
			alert.addButtonWithTitle(alternateButtonTitle);
		}

	  if (otherButtonTitle != null) {
			alert.addButtonWithTitle(otherButtonTitle);
		}

	  return alert;
	}

	/**
	 * Initializes the default NSAlert with a style of NSAlertStyle.NSWarning.
	 */
	public function init():NSAlert {
		m_buttons = new NSArray();
		m_app = NSApplication.sharedApplication();
		m_style = NSAlertStyle.NSWarning;
		return this;
	}

	/**
	 * Sets the alerts title text.
	 */
	public function setInformativeText(infoText:String):Void {
		m_info = infoText;
	}

	/**
	 * Returns the alerts message text.
	 */
	public function informativeText():String {
		return m_info;
	}

	/**
	 * Sets the alerts title text.
	 */
	public function setMessageText(messageText:String):Void {
		m_msg = messageText;
	}

	/**
	 * Returns the alerts title text.
	 */
	public function messageText():String {
		return m_msg;
	}

	//- (void)setIcon:(NSImage *)icon
	//- (NSImage *)icon

	/**
	 * Adds a button to alert labeled with aTitle, then returns it. The button
	 * is placed to the left side of the existing buttons.
	 *
	 * By default the first button is the default push button.
	 */
	public function addButtonWithTitle(aTitle:String):NSButton {
	  if (aTitle == null) {
	  	return null;
	  }

	  var button:NSButton = new NSButton();
	  button.initWithFrame(new NSRect(0, 0, ASAlertPanel["BtnMinWidth"], ASAlertPanel["BtnMinHeight"]));
	  var count:Number = m_buttons.count();

	  button.setTitle(aTitle);
	  button.setTarget(this);
	  button.setAction("buttonAction");

	  if (count == 0) {
			button.setTag(NSAlertReturn.NSFirstButton.value);
			button.setKeyEquivalent("\r");
		} else {
			button.setTag(NSAlertReturn.NSFirstButton.value + count);
			if (aTitle == "Cancel") {
				button.setKeyEquivalent("e");
			} else if (aTitle == "Don't Save") {
				button.setKeyEquivalent("D");
				button.setKeyEquivalentModifierMask(NSEvent.NSCommandKeyMask);
			}
		}

	  m_buttons.addObject(button);
	  return button;
	}

	/**
	 * Returns the alert's buttons.
	 */
	public function buttons():NSArray {
	  return m_buttons;
	}

	/**
	 * Sets whether the alert displays a help button. If TRUE, the help
	 * button is displayed.
	 *
	 * When the button is pressed, an alertShowsHelp method is called in the
	 * delegate. The method signiture is as follows:
	 * 	alertShowsHelp(alert:NSAlert):Boolean
	 *
	 * If the delegate returns FALSE, or delegate is null, the NSHelpManager is
	 * asked to show help, passed a null book and the anchor specified by
	 * setHelpAnchor.
	 */
	public function setShowsHelp(showsHelp:Boolean):Void {
	  m_showsHelp = showsHelp;
	}

	/**
	 * Returns TRUE if the alert has a help button, or FALSE if it doesn't.
	 *
	 * @see org.actionstep.NSAlert#setShowsHelp
	 */
	public function showsHelp():Boolean {
	  return m_showsHelp;
	}

	/**
	 * Sets the HTML text anchor sent to the NSHelpManager if showsHelp is TRUE
	 * and no delegate has been specified.
	 */
	public function setHelpAnchor(anchor:String):Void {
	  m_helpAnchor = anchor;
	}

	/**
	 * Returns the HTML text anchor sent to the NSHelpManager if showsHelp is
	 * TRUE and no delegate has been specified.
	 */

	public function helpAnchor():String {
	  return m_helpAnchor;
	}

	/**
	 * Sets the alert style.
	 *
	 * @see org.actionstep.constants.NSAlertStyle
	 */
	public function setAlertStyle(style:NSAlertStyle):Void {
	  m_style = style;
	}

	/**
	 * Returns the alert style.
	 *
	 * @see org.actionstep.constants.NSAlertStyle
	 */
	public function alertStyle():NSAlertStyle {
	  return m_style;
	}

	/**
	 * Sets the delegate that displays help for the alert.
	 */
	public function setDelegate(delegate:Object) {
	  m_delegate = delegate;
	}

	/**
	 * Returns the delegate that displays help for the alert.
	 */
	public function delegate():Object {
	  return m_delegate;
	}

	/*
	- (int)runModal
	{
	  // FIXME
	  return NSAlertFirstButtonReturn;
	}

	- (void)beginSheetModalForWindow:(NSWindow *)window
			   modalDelegate:(id)delegate
			  didEndSelector:(SEL)didEndSelector
			     contextInfo:(void *)contextInfo
	{
	// FIXME
	}*/
	//should be uncasted, if Cocoa-styled

	/**
	 * Returns the modal dialog.
	 */
	public function window():ASAlertPanel {
		return m_sheet;
	}

	//! remove sheet

	/**
	 * Runs the modal alert in window. When the alert recieves user input,
	 * it invokes the didEndSelector in delegate. It's method signature should
	 * be as follows:
	 * 	alertDidEnd(alert:NSAlert, returnCode:constants.NSRunResponse, context:Object):Void
	 *
	 * Please note:
	 *	The delegate must either be a subclass of NSObject or have a method
	 * 	called respondsToSelector who when passed a string selector returns
	 *	TRUE if the object can respond, or FALSE if it can't.
	 */
	public function beginSheetModalForWindowModalDelegateDidEndSelectorContextInfo(
			window:NSWindow, delegate:Object, sel:String, ctxt:Object):Void {
		var list:Array = m_buttons.internalList();
		/*
		m_sheet = ASAlertPanel.NSGetAlert("", m_msg, list[0].title(), list[1].title(), list[2].title());

		window.resignKeyWindow();
		m_sheet.display();

		//add it to arg array
		arguments.unshift(m_sheet);
		m_app.beginSheetModalForWindowModalDelegateDidEndSelectorContextInfo.apply(m_app, arguments);
		*/

		m_sheet = ASAlertPanel.__NSGetAlertSheet("Alert", "foo", "foo", "foo", m_msg, m_info);

		var labels:Array = ["def", "alt", "oth"];
		var dest:Array = m_sheet["m_btns"];
		var i:Number = dest.length;
		while(i--) {
			dest[i].removeFromSuperview();
			m_sheet["m_"+labels[i]] = list[i];
		}

		m_sheet["m_btns"] = list;
		i = list.length;
		var view:NSView = m_sheet.contentView();
		while(i--) {
			list[i].m_alert = m_sheet;
			view.addSubview(list[i]);
		}
		m_sheet.makeFirstResponder(list[0]);

		ASAlertPanel.__NSRunAlertSheet(m_sheet, window, delegate, sel, null, ctxt);
	}

	private function buttonAction(sender:Object):Void {
		m_sheet["buttonAction"].call(m_sheet, sender);
	}
}