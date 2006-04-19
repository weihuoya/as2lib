/*
 Copyright aswing.org, see the LICENCE.txt.
*/
import org.aswing.AbstractButton;
import org.aswing.border.Border;
import org.aswing.Component;
import org.aswing.FocusManager;
import org.aswing.geom.Rectangle;
import org.aswing.graphics.Graphics;
import org.aswing.plaf.basic.BasicGraphicsUtils;
import org.aswing.plaf.basic.border.ButtonBorder;

/**
 *
 * @author iiley
 */
class org.aswing.plaf.basic.border.ToolBarButtonBorder extends ButtonBorder {
	
	private static var toolBarButtonBordeInstance:Border;
	
	/**
	 * this make shared instance and construct when use.
	 */	
	public static function createInstance():Border{
		if(toolBarButtonBordeInstance == null){
			toolBarButtonBordeInstance = new ToolBarButtonBorder();
		}
		return toolBarButtonBordeInstance;
	}
	
	function ToolBarButtonBorder() {
		super();
	}
	
	/**
	 * paint the ButtonBorder content.
	 */
    public function paintBorder(c:Component, g:Graphics, bounds:Rectangle):Void{
    	var isPressed:Boolean = false;
    	var button:AbstractButton = AbstractButton(c);
    	if(button != null){
			isPressed = button.getModel().isPressed() || button.getModel().isSelected();
			if((button.isFocusOwner() && FocusManager.getCurrentManager().isTraversing()) || button.getModel().isRollOver() || isPressed){
				BasicGraphicsUtils.drawBezel(g, bounds, isPressed, shadow,
                                   darkShadow, highlight, lightHighlight);
			}
    	}
    }

}
