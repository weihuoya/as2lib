﻿/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.border.Border;
import org.aswing.Component;
import org.aswing.graphics.Graphics;
import org.aswing.graphics.SolidBrush;
import org.aswing.JWindow;
import org.aswing.LookAndFeel;
import org.aswing.plaf.ComponentUI;
import org.aswing.plaf.WindowUI;
import org.aswing.UIManager;

 
/**
 *
 * @author iiley
 */
class org.aswing.plaf.basic.BasicWindowUI extends WindowUI{

    // Shared UI object
    private static var windowUI:WindowUI;
	
	private var contentPaneBorder:Border;
    public static function createInstance(c:Component):ComponentUI {
		if(windowUI == null) {
            windowUI = new BasicWindowUI();
		}
        return windowUI;
    }
    
	public function BasicWindowUI(){
		contentPaneBorder = UIManager.getBorder("Window.contentPaneBorder");
	}

    public function installUI(c:Component):Void {
        var p:JWindow = JWindow(c);
        installDefaults(p);
    }

    public function uninstallUI(c:Component):Void {
        var p:JWindow = JWindow(c);
        uninstallDefaults(p);
    }

    private function installDefaults(p:JWindow):Void {
    	var pp:String = "Window.";
        LookAndFeel.installColorsAndFont(p, pp + "background", pp + "foreground", pp + "font");
        LookAndFeel.installBorder(p, "Window.border");
        LookAndFeel.installBasicProperties(p, pp);
        p.getContentPane().setBorder(contentPaneBorder);
    }

    public function create(c:Component):Void{
    	var window:JWindow = JWindow(c);
    	var modalMC:MovieClip = window.getModalMC();
		var g:Graphics = new Graphics(modalMC);
		g.fillRectangle(new SolidBrush(UIManager.getColor("Window.modalColor").getRGB(), 30), 0, 0, 1, 1);
		
    	window.resetModalMC();
    }
    
    private function uninstallDefaults(p:JWindow):Void {
        LookAndFeel.uninstallBorder(p);
    }
}
