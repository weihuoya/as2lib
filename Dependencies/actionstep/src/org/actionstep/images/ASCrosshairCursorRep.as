/* See LICENSE for copyright and terms of use */

import org.actionstep.NSImageRep;
import org.actionstep.NSSize;
import org.actionstep.NSPoint;

/**
 * This class draws the crosshair cursor. 
 * 
 * @author Scott Hyndman
 */
class org.actionstep.images.ASCrosshairCursorRep extends NSImageRep 
{
	public function ASCrosshairCursorRep() 
	{ 
		m_size = new NSSize(16,16);
		super();
	}

	public function description():String 
	{
		return "ASCrosshairCursorRep(size=" + size() + ")";
	}
	
	public function draw():Void
	{
		var mc:MovieClip = m_drawClip;
		var pt:NSPoint = m_drawPoint;
		var sz:NSSize = size();
		
		mc.lineStyle(1, 0x000000, 100);

		mc.moveTo(pt.x + sz.width / 2, pt.y);
		mc.lineTo(pt.x + sz.width / 2, pt.y + sz.height);
		mc.moveTo(pt.x, pt.y + sz.height / 2);
		mc.lineTo(pt.x + sz.width, pt.y + sz.height / 2);	
	}	
}