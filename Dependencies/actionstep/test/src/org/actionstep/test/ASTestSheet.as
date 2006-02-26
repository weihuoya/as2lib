/* See LICENSE for copyright and terms of use */

import org.actionstep.alert.ASAlertPanel;
import org.actionstep.ASUtils;
import org.actionstep.constants.NSAlertReturn;
import org.actionstep.constants.NSAlertStyle;
import org.actionstep.constants.NSBezelStyle;
import org.actionstep.NSAlert;
import org.actionstep.NSApplication;
import org.actionstep.NSButton;
import org.actionstep.NSColor;
import org.actionstep.NSDictionary;
import org.actionstep.NSEvent;
import org.actionstep.NSNotificationCenter;
import org.actionstep.NSRect;
import org.actionstep.NSTextField;
import org.actionstep.NSWindow;
import org.actionstep.test.ASTestView;

/**
 * Tests the <code>org.actionstep.NSAlert</code> class.
 *
 * @author Tay Ray Chuan
 */
class org.actionstep.test.ASTestSheet {
	public static var self:Object = ASTestSheet;
	public static var app:NSApplication;
	public static var main:NSWindow, other:NSWindow;
	public static var view1:ASTestView, view2:ASTestView;
	public static var b0:NSButton, b1:NSButton, b2:NSButton, b3:NSButton;
	public static var textField:NSTextField, textField2:NSTextField;
	public static var nc:NSNotificationCenter;
	public static var msg:String;
	public static var alert:NSAlert;

	public static function test() {
		app = NSApplication.sharedApplication();
		trace("app: "+app);
		main= (new NSWindow()).initWithContentRectStyleMask(new NSRect(50,50,250,250), NSWindow.NSTitledWindowMask);
		main.setTitle("Main");
		other = (new NSWindow()).initWithContentRectStyleMask(new NSRect(400,100,250,250), NSWindow.NSTitledWindowMask);
		other.setTitle("Some Other Window");

		view1 = ASTestView((new ASTestView()).initWithFrame(new NSRect(0,0,25,25)));
		view1.setBorderColor(new NSColor(0xFFF000));
		view2 = ASTestView((new ASTestView()).initWithFrame(new NSRect(0,0,250,250)));
		view2.setBorderColor(new NSColor(0xFF0000));

		b0 = (new NSButton()).initWithFrame(new NSRect(10,20,100,30));
		b0.setTitle("NSAlert");
		b0.sendActionOn(NSEvent.NSLeftMouseUpMask);
		b0.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
		b0.setTarget(self);
		b0.setAction("trigger");
		trace(b0.target());
		trace(b0.action());

		b1 = (new NSButton()).initWithFrame(new NSRect(10,60,100,30));
		b1.setTitle("NSBegin");
		b1.sendActionOn(NSEvent.NSLeftMouseUpMask);
		b1.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
		b1.setTarget(self);
		b1.setAction("normal");

		b2 = (new NSButton()).initWithFrame(new NSRect(10,100,100,30));
		b2.setTitle("NSBeginCritical");
		b2.sendActionOn(NSEvent.NSLeftMouseUpMask);
		b2.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
		b2.setTarget(self);
		b2.setAction("critical");

		b3 = (new NSButton()).initWithFrame(new NSRect(10,140,100,30));
		b3.setTitle("NSBeginInfo");
		b3.sendActionOn(NSEvent.NSLeftMouseUpMask);
		b3.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
		b3.setTarget(self);
		b3.setAction("informational");

		textField = (new NSTextField()).initWithFrame(new NSRect(10,200,120,30));
		textField2 = (new NSTextField()).initWithFrame(new NSRect(10,160,120,30));

		view1.addSubview(b0);
		view1.addSubview(b1);
		view1.addSubview(b2);
		view1.addSubview(b3);
		view1.addSubview(textField);

		view2.addSubview(textField2);

		main.setContentView(view1);
		other.setContentView(view2);

		msg = "Delete the record?";
		textField.setStringValue(msg);
		main.makeMainWindow();

		app.run();

		trigger();
	}

	//modified code from:
	//http://developer.apple.com/documentation/Cocoa/Conceptual/Sheets/Tasks/UsingAlertSheets.html#//apple_ref/doc/uid/20001045
	public static function trigger(button:NSButton) {
		trace("Starting sheet...");
		var str:String = textField.stringValue();
		if(str==null || str=="") {
			str = msg;
			textField.setStringValue(msg);
			textField.drawCell(textField.cell());
		}
		alert = (new NSAlert()).init();
		alert.addButtonWithTitle("OK");
		alert.addButtonWithTitle("Cancel");
		alert.addButtonWithTitle("Don't Save");
		alert.setMessageText(str);
		alert.setInformativeText("Deleted records cannot be restored.");
		alert.setAlertStyle(NSAlertStyle.NSWarning);

		alert.beginSheetModalForWindowModalDelegateDidEndSelectorContextInfo
		(main, self, "alertDidEndReturnCodeContextInfo", null);
	}

	public static function alertDidEndReturnCodeContextInfo
	(sheet:NSWindow, ret:NSAlertReturn, ctxt:NSDictionary) {
		var ans:NSDictionary = ASUtils.findMatch([NSAlertReturn], ret);
		trace("button clicked: "+ans.objectForKey("prop"));
		trace("releasing sheet... ");
		sheet.close();
	}

	public static function normal() {
		ASAlertPanel.NSBeginAlertSheet
		(null, "OK", "Cancel", "None", main, self, "done", "dismiss",
		NSDictionary.dictionaryWithObjectsAndKeys(null, "button", "foo", 5)
		, "Foo");
	}

	//look like NSObject
	public static function respondsToSelector(sel:String):Boolean {
		return self.hasOwnProperty(sel);
	}

	public static function toString():String {
		return "Test::ASTestPanel";
	}
}
