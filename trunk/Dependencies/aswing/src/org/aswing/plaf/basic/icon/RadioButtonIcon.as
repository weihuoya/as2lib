/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.ASColor;
import org.aswing.ButtonModel;
import org.aswing.Component;
import org.aswing.graphics.Brush;
import org.aswing.graphics.GradientBrush;
import org.aswing.graphics.Graphics;
import org.aswing.graphics.SolidBrush;
import org.aswing.Icon;
import org.aswing.JRadioButton;
import org.aswing.plaf.UIResource;
import org.aswing.UIDefaults;
import org.aswing.UIManager;
 
/**
 *
 * @author iiley
 */
class org.aswing.plaf.basic.icon.RadioButtonIcon implements Icon, UIResource{
    private var shadow:ASColor;
    private var darkShadow:ASColor;
    private var highlight:ASColor;
    private var lightHighlight:ASColor;

	private static var instance:Icon;
	/**
	 * this make shared instance and construct when use.
	 */	
	public static function createInstance():Icon{
		if(instance == null){
			instance = new RadioButtonIcon();
		}
		return instance;
	}

	private function RadioButtonIcon(){
		super();
		var table:UIDefaults = UIManager.getLookAndFeelDefaults();
		shadow = table.getColor("RadioButton.shadow");
		darkShadow = table.getColor("RadioButton.darkShadow");
		highlight = table.getColor("RadioButton.light");
		lightHighlight = table.getColor("RadioButton.highlight");
	}

	public function getIconWidth():Number{
		return 13;
	}

	public function getIconHeight():Number{
		return 13;
	}

	public function paintIcon(com:Component, g:Graphics, x:Number, y:Number):Void{
		var rb:JRadioButton = JRadioButton(com);
		var model:ButtonModel = rb.getModel();
		var drawDot:Boolean = model.isSelected();
		
		var periphery:ASColor = darkShadow;
		var middle:ASColor = highlight;
		var inner:ASColor = shadow;
		var dot:ASColor = rb.getForeground();
		
		// Set up colors per RadioButtonModel condition
		if (!model.isEnabled()) {
			periphery = middle = inner = rb.getBackground();
			dot = darkShadow;
		} else if (model.isPressed()) {
			periphery = shadow;
			inner = darkShadow;
		}
		
		var w:Number = getIconWidth();
		var h:Number = getIconHeight();
		var cx:Number = x + w/2;
		var cy:Number = y + h/2;
		var xr:Number = w/2;
		var yr:Number = h/2;
		
		
	    var colors:Array = [0xD5D5D5, 0x8D8D8D];
		var alphas:Array = [100, 100];
    	var ratios:Array = [0, 255];
	    var matrix:Object = {matrixType:"box", x:cx-xr, y:cy-yr, w:xr*2, h:yr*2, r:(90/180)*Math.PI};        
	    var gBrush:GradientBrush=new GradientBrush(GradientBrush.LINEAR, colors, alphas, ratios, matrix);
		g.fillEllipse(gBrush, cx-xr, cy-yr, xr*2, yr*2);
		
		
		xr--;
		yr--;
		var sbrush:SolidBrush = new SolidBrush(middle);
		g.fillEllipse(sbrush, cx-xr, cy-yr, xr*2, yr*2);
		
		xr--;
		yr--;
		sbrush = new SolidBrush(shadow, 1);
		g.fillEllipse(sbrush, cx-xr, cy-yr, xr*2, yr*2);
		
		if(drawDot){
			xr = w/5;
			yr = h/5;
			var brush:Brush = new SolidBrush(middle);
			brush = new SolidBrush(dot);
			g.fillEllipse(brush, cx-xr, cy-yr, xr*2, yr*2);			
		}
	}
	public function uninstallIcon(com:Component):Void{
	}
}
