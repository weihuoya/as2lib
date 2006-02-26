/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.AbstractButton;
import org.aswing.ASColor;
import org.aswing.Component;
import org.aswing.geom.Rectangle;
import org.aswing.graphics.GradientBrush;
import org.aswing.graphics.Graphics;
import org.aswing.graphics.SolidBrush;
import org.aswing.plaf.basic.BasicButtonUI;
import org.aswing.plaf.ComponentUI;
 
/**
 *
 * @author iiley
 */
class org.aswing.plaf.asw.ASWingButtonUI extends BasicButtonUI{
	/*shared instance*/
	private static var asWingButtonUI:ASWingButtonUI;
	
    public static function createInstance(c:Component):ComponentUI {
    	if(asWingButtonUI == null){
    		asWingButtonUI = new ASWingButtonUI();
    	}
        return asWingButtonUI;
    }
    
    public function ASWingButtonUI(){
    	super();
    }
    
    /**
     * Paint gradient background for AsWing LAF Buttons.
     */
    private function paintBackGround(com:Component, g:Graphics, b:Rectangle):Void{
    	var c:AbstractButton = AbstractButton(com);
    	paintASWingLAFButtonBackGround(c, g, b);
    }
    
    public static function paintASWingLAFButtonBackGround(c:AbstractButton, g:Graphics, b:Rectangle):Void{
		var bgColor:ASColor = (c.getBackground() == null ? ASColor.WHITE : c.getBackground());

		if(c.isOpaque()){
			if(c.getModel().isPressed() || c.getModel().isSelected()){
				g.fillRectangle(new SolidBrush(bgColor), b.x, b.y, b.width, b.height);
				return;
			}
			g.fillRectangle(new SolidBrush(bgColor), b.x, b.y, b.width, b.height);
			var x1:Number = b.x;
			var y1:Number = b.y;
			var x2:Number = x1 + b.width;
			var y2:Number = y1 + b.height;
	        var colors:Array = [0xFFFFFF, 0xFFFFFF];
			var alphas:Array = [75, 0];
			var ratios:Array = [0, 100];
		    var matrix:Object = {matrixType:"box", x:x1, y:y1, w:b.width, h:b.height, r:(90/180)*Math.PI};        
	        var brush:GradientBrush=new GradientBrush(GradientBrush.LINEAR, colors, alphas, ratios, matrix);
	        g.fillRectangle(brush,x1,y1,x2-3,y2);
		}    	
    }
	
}
