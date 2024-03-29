/* See LICENSE for copyright and terms of use */

import org.actionstep.NSImageRep;
import org.actionstep.NSSize;
import org.actionstep.NSRect;
import org.actionstep.ASTheme;

/**
 * This class draws the pattern to be repeated horizontally and scrolled on an
 * indeterminate <code>org.actionstep.NSProgressIndicator</code> in bar mode.
 * 
 * @author Scott Hyndman
 */
class org.actionstep.images.ASProgressBarDeterminatePatternRep extends NSImageRep 
{
	public function ASProgressBarDeterminatePatternRep() 
	{
		m_size = new NSSize(18,18);
		super();
	}

	public function description():String 
	{
		return "ASProgressBarDeterminatePatternRep(size=" + size() + ")";
	}
	
	public function draw():Void
	{
		ASTheme.current().drawProgressBarPatternInRectWithClipIndeterminate(
			new NSRect(m_drawPoint.x, m_drawPoint.y, m_size.width, m_size.height), m_drawClip, false);
	}
}