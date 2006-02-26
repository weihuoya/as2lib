/* See LICENSE for copyright and terms of use */

import org.actionstep.NSApplication;
import org.actionstep.NSComboBox;
import org.actionstep.NSRect;
import org.actionstep.NSView;
import org.actionstep.NSTextField;
import org.actionstep.NSWindow;
import org.actionstep.NSColor;

/**
 * Tests the <code>org.actionstep.NSComboBox</code> class.
 *
 * @author Richard Kilmer
 */
class org.actionstep.test.ASTestComboBox {
	public static function test():Void
	{
	  var object:Object = new Object();
		var app:NSApplication = NSApplication.sharedApplication();
		var window:NSWindow = (new NSWindow()).initWithContentRect(new NSRect(0,0,500,500));
		var view:NSView = (new NSView()).initWithFrame(new NSRect(0,0,500,500));

		var comboBox:NSComboBox = new NSComboBox();
		comboBox.initWithFrame(new NSRect(10, 10, 150, 25));
		view.addSubview(comboBox);

		//
		// The modulus operator allows us to test the different ways
		//
		var data:Array = ["Rich", "Dave", "Tom", "Mark", "Ryan", "Ingrid", "Jessica", "Nicolas"];
		var i:Number = data.length;
		while(i--) {
			switch(i%3) {
		case 0:
			data[i] = createItemWithLabel(data[i]);
			break;
		case 1:
			data[i] = createItemWithLabelValue(data[i]);
			break;
		case 2:
			data[i].ctxt = "context for "+data[i];
			}
		}
		comboBox.addItemsWithObjectValues(data);

		var comboBox2:NSComboBox = new NSComboBox();
		comboBox2.initWithFrame(new NSRect(10, 45, 100, 28));
		comboBox2.setEditable(false);
		comboBox2.setHasVerticalScroller(false);
		comboBox2.addItemsWithObjectValues(["Rich", "Dave", "Tom", "Mark", "Ryan", "Ingrid", "Jessica", "Nicolas"]);
		comboBox2.selectItemWithObjectValue("Tom");
		view.addSubview(comboBox2);

		var o:Object = new Object();
		o.changed = function(box:NSComboBox) {
		  trace(box.objectValueOfSelectedItem());
		};

		comboBox.setTarget(o);
		comboBox.setAction("changed");
		comboBox2.setTarget(o);
		comboBox2.setAction("changed");

		var tf:NSTextField = new NSTextField();
		tf.initWithFrame(new NSRect(10, 75, 100, 25));
		tf.setBackgroundColor(new NSColor(0xaaaa00));
		tf.setBorderColor(new NSColor(0x000000));
		tf.setDrawsBackground(false);
		view.addSubview(tf);

		window.setContentView(view);
		app.run();
	}

	//
	// The following 2 functions shows how you can include context data which will not be
	// touched by the control.
	//

	private static function createItemWithLabel(label:String):Object {
		return {
			ctxt: "context for "+label,
			label: label,
			toString: function():String {
				return "toString() of "+label;
			}
		};
	}

	private static function createItemWithLabelValue(label:String):Object {
		return {
			ctxt: "context for "+label,
			label: label,
			data: "data of "+label
		};
	}
}
