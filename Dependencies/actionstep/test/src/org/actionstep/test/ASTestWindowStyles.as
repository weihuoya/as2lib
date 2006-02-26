/* See LICENSE for copyright and terms of use */

import org.actionstep.*;
import org.actionstep.test.ASTestView;
import org.actionstep.test.windowStyles.ASTestWindowIconRep;
import org.actionstep.constants.NSWindowOrderingMode;

class org.actionstep.test.ASTestWindowStyles {

  public static function test() {
    var app:NSApplication = NSApplication.sharedApplication();
    
    var window:NSWindow;
    var view:ASTestView;
    var window4:NSWindow;
    var view4:ASTestView;
    
    var target:Object = new Object();
    target.createDesktopWindow = function(button) {
      window = (new NSWindow()).initWithContentRectStyleMask(new NSRect(80,25,200,200), 
        NSWindow.NSTitledWindowMask
        | NSWindow.NSClosableWindowMask);
      window.setTitle("Desktop Window");
      view = new ASTestView();
      view.initWithFrame(new NSRect(0,0,20,20));
      view.setBackgroundColor(new NSColor(0xDDDD55));
      window.setContentView(view);
      window.display();
      window.setLevel(NSWindow.NSDesktopWindowLevel);

    };
    target.createNormalWindow = function(button) {
      window = (new NSWindow()).initWithContentRectStyleMask(new NSRect(40,25,200,200), 
      	NSWindow.NSTitledWindowMask 
      	| NSWindow.NSResizableWindowMask
      	| NSWindow.NSClosableWindowMask
      	| NSWindow.NSMiniaturizableWindowMask);
      window.setTitle("Normal Window");
      window.setBackgroundColor(new NSColor(0x55DD55));
      window.display();
    };
    target.createTopWindow = function(button) {
      window = (new NSWindow()).initWithContentRectStyleMask(new NSRect(80,25,150,100), 
        NSWindow.NSTitledWindowMask | NSWindow.NSResizableWindowMask
        | NSWindow.NSClosableWindowMask);
      window.setTitle("Top Window");
      view = new ASTestView();
      view.init();
      //view.initWithFrame(new NSRect(0,0,20,20));
      view.setBackgroundColor(new NSColor(0x55DDFF));
      window.setContentView(view);
      window.setShowsResizeIndicator(false);
      window.display();
      window.setLevel(NSWindow.NSModalPanelWindowLevel);
    };

    //
    // Create icon for window4
    //
    var icon:NSImage = (new NSImage()).init();
    icon.addRepresentation(new ASTestWindowIconRep());
    
    window4 = (new NSWindow()).initWithContentRectStyleMask(new NSRect(50,50,200,200), NSWindow.NSTitledWindowMask  | NSWindow.NSResizableWindowMask);
    window4.setTitle("Higher level Control window");
    window4.setIcon(icon);
    view4 = new ASTestView();
    view4.initWithFrame(new NSRect(0,0,20,20));
    window4.setContentView(view4);
    window4.setLevel(NSWindow.NSStatusWindowLevel);
    
    var childWnd:NSWindow = (new NSWindow()).initWithContentRectStyleMask(new NSRect(240,40,60,60), NSWindow.NSTitledWindowMask  | NSWindow.NSResizableWindowMask);
    childWnd.setTitle("Child window");
    childWnd.setBackgroundColor(ASColors.grayColor());
    childWnd.setLevel(NSWindow.NSStatusWindowLevel);
    
    var button1:NSButton = (new NSButton()).initWithFrame(new NSRect(10,10,150,30));
    
    button1.setTitle("Create Desktop Window");
    view4.addSubview(button1);
    button1.setTarget(target);
    button1.setAction("createDesktopWindow");

    var button2:NSButton = (new NSButton()).initWithFrame(new NSRect(10,50,150,30));
    button2.setTitle("Create Normal Window");
    view4.addSubview(button2);
    button2.setTarget(target);
    button2.setAction("createNormalWindow");

    var button3:NSButton = (new NSButton()).initWithFrame(new NSRect(10,90,150,30));
    button3.setTitle("Create Top Window");
    view4.addSubview(button3);
    button3.setTarget(target);
    button3.setAction("createTopWindow");
    
    window4.setMinSize(new NSSize(200, 200));
    
    var o:Object = new Object();
    o.windowWillResizeToSize = function(win:NSWindow, size:NSSize) {
      //trace("Resize to: "+size);
      return size;
    };
    o.windowWillMove = function(notification:NSNotification) {
      //trace("Window now at: "+notification.object.frame().origin);
    };
    window4.setDelegate(o);

    app.run();
    window4.addChildWindowOrdered(childWnd, NSWindowOrderingMode.NSWindowBelow);
  }
}
