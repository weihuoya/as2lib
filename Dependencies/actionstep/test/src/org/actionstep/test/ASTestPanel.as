/* See LICENSE for copyright and terms of use */

import org.actionstep.alert.ASAlertPanel;
import org.actionstep.ASUtils;
import org.actionstep.constants.NSAlertReturn;
import org.actionstep.constants.NSBezelStyle;
import org.actionstep.constants.NSRunResponse;
import org.actionstep.NSApplication;
import org.actionstep.NSButton;
import org.actionstep.NSColor;
import org.actionstep.NSEvent;
import org.actionstep.NSRect;
import org.actionstep.NSTextField;
import org.actionstep.NSWindow;
import org.actionstep.test.ASTestView;
import org.actionstep.NSDictionary;

/**
 * Tests the <code>org.actionstep.NSAlert</code> class.
 *
 * @author Tay Ray Chuan
 */
class org.actionstep.test.ASTestPanel {
	public static var self:Object = ASTestPanel;
	public static var app:NSApplication = NSApplication.sharedApplication();
	public static var main:NSWindow, other:NSWindow;
	public static var view1:ASTestView, view2:ASTestView;
	public static var b1:NSButton, b2:NSButton, b3:NSButton;
	public static var textField:NSTextField, textField2:NSTextField;
	public static var alertArgs:Array;

	public static function test() {
		trace("app: "+app);
		main= (new NSWindow()).initWithContentRectStyleMask(new NSRect(50,50,250,250), NSWindow.NSTitledWindowMask);
		main.setTitle("Main");
		other = (new NSWindow()).initWithContentRectStyleMask(new NSRect(400,100,250,250), NSWindow.NSTitledWindowMask);
		other.setTitle("Some Other Window");

		view1 = ASTestView((new ASTestView()).initWithFrame(new NSRect(0,0,25,25)));
		view1.setBorderColor(new NSColor(0xFFF000));
		view2 = ASTestView((new ASTestView()).initWithFrame(new NSRect(0,0,250,250)));
		view2.setBorderColor(new NSColor(0xFF0000));

		b1 = (new NSButton()).initWithFrame(new NSRect(10,20,80,30));
		b1.setTitle("panel");
		b1.sendActionOn(NSEvent.NSLeftMouseUpMask);
		b1.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
		b1.setTarget(self);
		b1.setAction("panel");

		b2 = (new NSButton()).initWithFrame(new NSRect(10,60,80,30));
		b2.setTitle("critical");
		b2.sendActionOn(NSEvent.NSLeftMouseUpMask);
		b2.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
		b2.setTarget(self);
		b2.setAction("critical");

		b3 = (new NSButton()).initWithFrame(new NSRect(10,100,80,30));
		b3.setTitle("informational");
		b3.sendActionOn(NSEvent.NSLeftMouseUpMask);
		b3.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
		b3.setTarget(self);
		b3.setAction("informational");

		textField = (new NSTextField()).initWithFrame(new NSRect(10,160,120,30));
		textField2 = (new NSTextField()).initWithFrame(new NSRect(10,160,120,30));

		view1.addSubview(b1);
		view1.addSubview(b2);
		view1.addSubview(b3);
		view1.addSubview(textField);

		view2.addSubview(textField2);

		main.setContentView(view1);
		other.setContentView(view2);

		main.makeMainWindow();

		app.run();

		alertArgs = [null,
		"A very long line of text...lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
		"OK","Cancel", "None", self, "done"];
	}

	public static function done(panel:ASAlertPanel, ret:Object) {
		if(ret==NSRunResponse.NSContinues)	return;
		var ans:NSDictionary = ASUtils.findMatch([NSAlertReturn,NSRunResponse], ret);
		trace("button clicked: "+ans.objectForKey("prop"));
		if(!panel.isSheet()) {
			ASAlertPanel.NSRelease(panel);
		}
	}

	//look like NSObject
	public static function respondsToSelector(sel:String):Boolean {
		return self.hasOwnProperty(sel);
	}

	/**
	* The following are wrapper functions.
	*/

	public static function panel() {
		ASAlertPanel.NSRunAlert.apply(ASAlertPanel, alertArgs);
	}

	public static function critical() {
		ASAlertPanel.NSRunCriticalAlert.apply(ASAlertPanel, alertArgs);
	}

	public static function informational() {
		ASAlertPanel.NSRunInformationalAlert.apply(ASAlertPanel, alertArgs);
	}

	public static function toString():String {
		return "Test::ASTestPanel";
	}
}