/* See LICENSE for copyright and terms of use */

import org.actionstep.NSApplication;
import org.actionstep.NSWindow;
import org.actionstep.NSDrawer;
import org.actionstep.constants.NSRectEdge;
import org.actionstep.NSRect;
import org.actionstep.NSSize;
import org.actionstep.ASColors;
import org.actionstep.NSView;
import org.actionstep.NSButton;
import org.actionstep.NSColor;
import org.actionstep.ASColoredView;

/**
 * @author Scott Hyndman
 */
class org.actionstep.test.ASTestDrawer {
	public static function test():Void {
		var app:NSApplication = NSApplication.sharedApplication();
		var wnd:NSWindow = (new NSWindow()).initWithContentRectStyleMask(
			new NSRect(50, 50, 200, 200),
			NSWindow.NSTitledWindowMask);
		wnd.setTitle("Window with drawer");
		wnd.setBackgroundColor(ASColors.lightGrayColor());
		
		//
		// Build drawer
		//
		var drawer:NSDrawer = (new NSDrawer()).initWithContentSizePreferredEdge(
			new NSSize(100, 100),
			NSRectEdge.NSMaxXEdge);
		drawer.setParentWindow(wnd);
		
		var drawerContent:ASColoredView = new ASColoredView();
		drawerContent.setBackgroundColor(new NSColor(0xDD0000));
		drawerContent.setBorderColor(new NSColor(0x330000));
		drawer.setContentView(drawerContent);
		
		var drawerBtn:NSButton = (new NSButton()).initWithFrame(
			new NSRect(5, 5, 90, 22));
		drawerBtn.setTitle("Foo");
		drawerContent.addSubview(drawerBtn);
		
		//
		// Build content view for window
		//
		var del:Object = {};
		del.toggleDrawer = function() {
			drawer.toggle(this);
		};
		
		var view:NSView = wnd.contentView();
		var btn:NSButton = (new NSButton()).initWithFrame(
			new NSRect(10, 10, 120, 22));
		btn.setTitle("Toggle drawer");
		btn.setTarget(del);
		btn.setAction("toggleDrawer");
		view.addSubview(btn);
		
		app.run();
	}
}