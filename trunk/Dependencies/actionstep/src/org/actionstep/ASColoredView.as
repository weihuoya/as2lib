/* See LICENSE for copyright and terms of use */

import org.actionstep.NSView;
import org.actionstep.NSColor;
import org.actionstep.NSRect;
import org.actionstep.ASColors;

/**
 * A view with a colored background and optionally a colored border. The default
 * background color is white. There is no border by default.
 *
 * To change the view's color, use <code>#setBackgroundColor()</code>.
 *
 * @author Scott Hyndman
 */
class org.actionstep.ASColoredView extends NSView {

	private var m_backgroundColor:NSColor;
	private var m_borderColor:NSColor;

	//******************************************************
	//*                    Construction
	//******************************************************

	/**
	 * Creates a new instance of <code>ASColoredView</code> with a white
	 * background color.
	 */
	public function ASColoredView()
	{
		m_backgroundColor = ASColors.whiteColor();
	}

	//******************************************************
	//*               Setting the view's color
	//******************************************************

	/**
	 * Sets the background color of the view to <code>color</code>.
	 */
	public function setBackgroundColor(color:NSColor):Void
	{
		m_backgroundColor = color;
	}

	/**
	 * Returns this view's background color.
	 */
	public function backgroundColor():NSColor
	{
		return m_backgroundColor;
	}

	/**
	 * Sets the border color of the view to <code>color</code>. If
	 * <code>color</code> is <code>null</code>, then no border will be drawn.
	 */
	public function setBorderColor(color:NSColor):Void
	{
		m_borderColor = color;
	}

	/**
	 * Returns this view's border color. A value of <code>null</code> means
	 * that no border is drawn on this view.
	 */
	public function borderColor():NSColor
	{
		return m_borderColor;
	}

	//******************************************************
	//*                  Drawing the view
	//******************************************************

	/**
	 * Returns the clip upon which the ASColoredView draws.
	 */
	public function mcDraw():MovieClip {
		return mcBounds();
	}
	
	/**
	 * Draws the view.
	 */
	public function drawRect(rect:NSRect):Void {
		with(mcDraw()) {
			clear();
			if (m_borderColor != null) {
				lineStyle(1, m_borderColor.value, 100);
			} else {
				lineStyle(1, m_backgroundColor.value, 100);
			}

			if (m_backgroundColor != null) {
				beginFill(m_backgroundColor.value, 100);
			}

			moveTo(0,0);
			lineTo(rect.size.width-1, 0);
			lineTo(rect.size.width-1, rect.size.height-1);
			lineTo(0, rect.size.height-1);
			lineTo(0, 0);

			if (m_backgroundColor != null) {
				endFill();
			}
		}
	}
}