/* See LICENSE for copyright and terms of use */

import org.actionstep.NSButtonCell;
import org.actionstep.NSRect;
import org.actionstep.NSView;
import org.actionstep.ASDraw;

/**
 * <p>Custom button drawing.</p>
 * <p><strong>Usage:</strong></p>
 * <code>
 * var btn:NSButton = (new NSButton()).initWithFrame(new NSRect(0, 0, 100, 22));
 * btn.setCell((new ASCustomButtonCell()).initTextCell("Foo"));
 * </code>
 * 
 * @author Scott Hyndman
 */
class org.actionstep.test.buttons.ASCustomButtonCell extends NSButtonCell {
	private function drawBezelWithFrameInView(cellFrame:NSRect, 
			inView:NSView):Void {
		
		var highlighted:Boolean = isHighlighted(); // highlight means pressed
		var mc:MovieClip = inView.mcBounds(); // the drawing surface
		
		if (highlighted) {
			ASDraw.solidCornerRectWithRect(mc, cellFrame, 3, 0x666666);
		} else {
			ASDraw.solidCornerRectWithRect(mc, cellFrame, 3, 0x888888);
		}
	}
}