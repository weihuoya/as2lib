/* See LICENSE for copyright and terms of use */
 
import org.actionstep.constants.NSBezelStyle;
import org.actionstep.constants.NSScrollerPart;
import org.actionstep.NSApplication;
import org.actionstep.NSButton;
import org.actionstep.NSEvent;
import org.actionstep.NSRect;
import org.actionstep.NSScroller;
import org.actionstep.NSStepper;
import org.actionstep.NSView;
import org.actionstep.NSWindow;
import org.actionstep.test.ASTestView;

/**
 * Tests the <code>org.actionstep.NSStepper</code> control.
 * 
 * @author Tay Ray Chuan
 */
class org.actionstep.test.ASTestStepper {
	public static function test() {

		var app:NSApplication = NSApplication.sharedApplication();
		var window1:NSWindow = (new NSWindow()).initWithContentRect(
			new NSRect(0,20,250,300));
		var view1:NSView = (new ASTestView()).initWithFrame(
			new NSRect(0,0,250,300));
		
		var testObject:Object = new Object();
		testObject.vscroller = function(scroller) {
			switch(scroller.hitPart()) {
				case NSScrollerPart.NSScrollerIncrementPage:
				case NSScrollerPart.NSScrollerIncrementLine:
					scroller.setFloatValue(scroller.floatValue() + .02);
					break;
				case NSScrollerPart.NSScrollerDecrementPage:
				case NSScrollerPart.NSScrollerDecrementLine:
					scroller.setFloatValue(scroller.floatValue() - .02);
					break;
			}
		};
		testObject.hscroller = function(scroller) {
			switch(scroller.hitPart()) {
				case NSScrollerPart.NSScrollerIncrementPage:
				case NSScrollerPart.NSScrollerIncrementLine:
					scroller.setFloatValue(scroller.floatValue() + .02);
					break;
				case NSScrollerPart.NSScrollerDecrementPage:
				case NSScrollerPart.NSScrollerDecrementLine:
					scroller.setFloatValue(scroller.floatValue() - .02);
					break;
			}
		};
		testObject.check = function(loc) {
			var row = loc.row;
			var x=_global.$c;
			if(x[row])	x[row] = false;
			else x[row]=true;
			trace(row+": "+x[row]);
		};
		testObject.trigger = function() {
			trace("bam");
		};
		testObject.foo = function() {
			trace("step");
		};
		
		var step:NSStepper =(new NSStepper()).initWithFrame(new NSRect(20, 20, 100, 100));
		
		step.setMaxValue(10);
		step.setAction("foo");
		step.setTarget(testObject);
		
		var vscroller:NSScroller = new NSScroller();
		vscroller.initWithFrame(new NSRect(180, 0, 20, 180));
		vscroller.setTarget(testObject);
		vscroller.setAction("vscroller");
		
		var hscroller:NSScroller = new NSScroller();
		hscroller.initWithFrame(new NSRect(0, 180, 180, 20));
		hscroller.setTarget(testObject);
		hscroller.setAction("hscroller");
		
		var triggerButton:NSButton = (new NSButton()).initWithFrame(new NSRect(10,240,70,30));
		triggerButton.setTitle("Draw");
		triggerButton.sendActionOn(NSEvent.NSLeftMouseDownMask);
		triggerButton.setContinuous(true);
		triggerButton.setPeriodicDelayInterval(.3, .5);
		triggerButton.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
		triggerButton.setAction("trigger");
		triggerButton.setTarget(testObject);
		
		view1.addSubview(triggerButton);
		view1.addSubview(vscroller);
		view1.addSubview(hscroller);		
		view1.addSubview(step);
		window1.setContentView(view1);
				
		app.run();
	}
}
