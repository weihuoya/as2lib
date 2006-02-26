/* See LICENSE for copyright and terms of use */

import org.actionstep.NSButton;
import org.actionstep.NSApplication;
import org.actionstep.test.buttons.ASCustomButtonCell;
import org.actionstep.NSRect;
import org.actionstep.NSWindow;

/**
 * @author Scott Hyndman
 */
class org.actionstep.test.ASTestCustomButton {
	public static function test():Void {
		var app:NSApplication = NSApplication.sharedApplication();
		var wnd:NSWindow = (new NSWindow()).initWithContentRect(
			new NSRect(0, 0, 300, 200));
			
		var btn:NSButton = (new NSButton()).initWithFrame(new NSRect(0, 0, 100, 22));
 		btn.setCell((new ASCustomButtonCell()).initTextCell("Foo"));
 		wnd.contentView().addSubview(btn);
 		
 		app.run();
	}
}