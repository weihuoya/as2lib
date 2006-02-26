/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.Component;
import org.aswing.Container;
import org.aswing.JPanel;
import org.aswing.SoftBoxLayout;

/**
 * @author iiley
 */
class org.aswing.SoftBox extends JPanel {
	
	/**
	 * SoftBox(axis:Number, gap:Number)<br>
	 * SoftBox(axis:Number) default gap to 0.
	 * Creates a panel with a SoftBoxLayout.
	 * @param axis the axis of layout.
	 *  {@link org.aswing.SoftBoxLayout#X_AXIS} or {@link org.aswing.SoftBoxLayout#Y_AXIS}
     * @param gap the gap between each component, default 0
	 * @see org.aswing.SoftBoxLayout
	 */
	public function SoftBox(axis:Number, gap:Number){
		super();
		setName("Box");
		setLayout(new SoftBoxLayout(axis, gap));
	}
	
	/**
	 * Creates and return a Horizontal SoftBox.
     * @param gap the gap between each component, default 0
     * @return a horizontal SoftBox.
	 */
	public static function createHorizontalBox(gap:Number):SoftBox{
		return new SoftBox(SoftBoxLayout.X_AXIS, gap);
	}
	
	/**
	 * Creates and return a Vertical SoftBox.
     * @param gap the gap between each component, default 0
     * @return a vertical SoftBox.
	 */
	public static function createVerticalBox(gap:Number):SoftBox{
		return new SoftBox(SoftBoxLayout.Y_AXIS, gap);
	}
	
	public static function createHorizontalGlue(width:Number):Component{
		var glue:Container = new JPanel();
		glue.setOpaque(false);
		glue.setMinimumSize(0, 0);
		glue.setPreferredSize(width, 0);
		glue.setMaximumSize(width, Number.MAX_VALUE);
		return glue;
	}
	
	public static function createVerticalGlue(height:Number):Component{
		var glue:Container = new JPanel();
		glue.setOpaque(false);
		glue.setMinimumSize(0, 0);
		glue.setPreferredSize(0, height);
		glue.setMaximumSize(Number.MAX_VALUE, height);
		return glue;
	}

}
