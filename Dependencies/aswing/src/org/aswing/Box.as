/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.BoxLayout;
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.JPanel;

/**
 * @author iiley
 */
class org.aswing.Box extends JPanel{
		
	/**
	 * Box(axis:Number, gap:Number)<br>
	 * Box(axis:Number) default gap to 0.
	 * Creates a panel with a BoxLayout.
	 * @param axis (optional)the axis of layout, default is X_AXIS
	 *  {@link org.aswing.BoxLayout#X_AXIS} or {@link org.aswing.BoxLayout#Y_AXIS}
     * @param gap (optional)the gap between each component, default 0
	 * @see org.aswing.SoftBoxLayout
	 */
	public function Box(axis:Number, gap:Number){
		super();
		setName("Box");
		setLayout(new BoxLayout(axis, gap));
	}
	
	/**
	 * Creates and return a Horizontal Box.
     * @param gap (optional)the gap between each component, default 0
     * @return a horizontal Box.
	 */	
	public static function createHorizontalBox(gap:Number):Box{
		return new Box(BoxLayout.X_AXIS, gap);
	}
	
	/**
	 * Creates and return a Vertical Box.
     * @param gap (optional)the gap between each component, default 0
     * @return a vertical Box.
	 */
	public static function createVerticalBox(gap:Number):Box{
		return new Box(BoxLayout.Y_AXIS, gap);
	}
	
	public static function createHorizontalGlue():Component{
		var glue:Container = new JPanel();
		glue.setOpaque(false);
		glue.setMinimumSize(0, 0);
		glue.setPreferredSize(0, 0);
		glue.setMaximumSize(0, Number.MAX_VALUE);
		return glue;
	}
	
	public static function createVerticalGlue():Component{
		var glue:Container = new JPanel();
		glue.setOpaque(false);
		glue.setMinimumSize(0, 0);
		glue.setPreferredSize(0, 0);
		glue.setMaximumSize(Number.MAX_VALUE, 0);
		return glue;
	}
}
