/* See LICENSE for copyright and terms of use */

import org.actionstep.ASBitmapImageRep;
import org.actionstep.NSSize;
import flash.display.BitmapData;

/**
 * @author Scott Hyndman
 */
class org.actionstep.themes.plastic.images.ASScrollerRightArrowRep 
		extends ASBitmapImageRep {
	
	/**
	 * Creates a new instance of the <code>ASScrollerRightArrowRep</code> class.
	 */
	public function ASScrollerRightArrowRep() {
		m_size = new NSSize(4, 8);
		m_image = new BitmapData(4, 8, true, null);
		
		var pPerRow:Array = new Array(8, 6, 4, 2);
		for (var i:Number = 0; i < 4; i++) {
			var cnt:Number = pPerRow[i];
			for (var j:Number = 4 - cnt / 2; j < 4 + cnt / 2; j++) {
				m_image.setPixel32(i, j, 0xFF000000);
			}
		}
	}
}