﻿/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.Component;
import org.aswing.geom.Dimension;
import org.aswing.geom.Rectangle;
import org.aswing.graphics.AdvancedPen;
import org.aswing.graphics.Graphics;
import org.aswing.Insets;
import org.aswing.JSeparator;
import org.aswing.LookAndFeel;
import org.aswing.plaf.ComponentUI;
import org.aswing.plaf.SeparatorUI;

/**
 * A Basic L&F implementation of SeparatorUI.  This implementation 
 * is a "combined" view/controller.
 *
 * @author iiley
 */
class org.aswing.plaf.basic.BasicSeparatorUI extends SeparatorUI {
	
	
	private static var basicSeparatorUI:BasicSeparatorUI;
    // ********************************
    //          Create Shared PLAF
    // ********************************
    public static function createInstance(c:Component):ComponentUI {
    	if(basicSeparatorUI == null){
    		basicSeparatorUI = new BasicSeparatorUI();
    	}
        return basicSeparatorUI;
    }
	
	
	public function BasicSeparatorUI(){
	}
	
	public function installUI(c:Component):Void{
		installDefaults(JSeparator(c));
		installListeners(JSeparator(c));
	}
	
	public function uninstallUI(c:Component):Void{
		uninstallDefaults(JSeparator(c));
		uninstallListeners(JSeparator(c));
	}
	
	public function installDefaults(s:JSeparator):Void{
		LookAndFeel.installColors(s, "Separator.background", "Separator.foreground");
		LookAndFeel.installBasicProperties(s, "Separator.");
		LookAndFeel.installBorder(s, "Separator.border");
	}
	
	public function uninstallDefaults(s:JSeparator):Void{
		LookAndFeel.uninstallBorder(s);
	}
	public function installListeners(s:JSeparator):Void{
	}
	public function uninstallListeners(s:JSeparator):Void{
	}
	
	public function paint(c:Component, g:Graphics, b:Rectangle):Void{
		var sp:JSeparator = JSeparator(c);
		if (sp.getOrientation() == JSeparator.VERTICAL){
			var pen:AdvancedPen = new AdvancedPen(c.getForeground(), 1, undefined, undefined, "none");
			g.drawLine(pen, b.x+0.5, b.y, b.x+0.5, b.y+b.height);
			pen.setASColor(c.getBackground());
			g.drawLine(pen, b.x+1.5, b.y, b.x+1.5, b.y+b.height);
		}else{
			var pen:AdvancedPen = new AdvancedPen(c.getForeground(), 1, undefined, undefined, "none");
			g.drawLine(pen, b.x, b.y+0.5, b.x+b.width, b.y+0.5);
			pen.setASColor(c.getBackground());
			g.drawLine(pen, b.x, b.y+1.5, b.x+b.width, b.y+1.5);
		}
	}
	
	public function getPreferredSize(c:Component):Dimension{
		var sp:JSeparator = JSeparator(c);
		var insets:Insets = sp.getInsets();
		if (sp.getOrientation() == JSeparator.VERTICAL){
			return insets.roundsSize(new Dimension(2, 0));
		}else{
			return insets.roundsSize(new Dimension(0, 2));
		}
	}
    public function getMaximumSize(c:Component):Dimension{
		var sp:JSeparator = JSeparator(c);
		var insets:Insets = sp.getInsets();
		var size:Dimension = insets.roundsSize();
		if (sp.getOrientation() == JSeparator.VERTICAL){
			return new Dimension(2 + size.width, Number.MAX_VALUE);
		}else{
			return new Dimension(Number.MAX_VALUE, 2 + size.height);
		}
    } 	
}
