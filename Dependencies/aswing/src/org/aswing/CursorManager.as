/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.ASWingUtils;
import org.aswing.Component;
import org.aswing.ElementCreater;
import org.aswing.Image;
import org.aswing.util.Delegate;
import org.aswing.util.DepthManager;

/**
 * The CursorManager, manage the cursor, hide system mouse cursor, show custom cursor, 
 * etc.
 * @author iiley
 */
class org.aswing.CursorManager {
	
	private static var cursorMC:MovieClip;
	private static var cursorImage:Image;
	
	/**
	 * showCustomCursor(cursorImage:Image, baseCom:Component)<br>
	 * showCustomCursor(cursorImage:Image)
	 * <p>
	 * Shows a custom image as a the cursor.
	 * @param image the cursor image
	 * @param  baseCom (optional), <code>baseCom.getRootAncestorMovieClip</code> to create cursor mc.
	 *         if miss this param, <code>ASWingUtils.getRootMovieClip()</code> will be 
	 *         called to create the cursor mc. 
	 */
	public static function showCustomCursor(image:Image, baseCom:Component):Void{
		cursorImage = image;
		var rootMC:MovieClip = baseCom.getRootAncestorMovieClip();
		if(rootMC == null){
			rootMC = ASWingUtils.getRootMovieClip();
		}
		
		cursorMC.onEnterFrame = undefined;
		cursorMC.removeMovieClip();
		cursorMC = ElementCreater.getInstance().createMC(rootMC);
		cursorImage.paintImage(cursorMC, 0, 0);
		Mouse.removeListener(CursorManager);
		Mouse.addListener(CursorManager);
		cursorMC.onEnterFrame = Delegate.create(CursorManager, onEnterFrame);
	}
	
	public static function hideCustomCursor():Void{
		cursorMC.onEnterFrame = undefined;
		cursorMC.removeMovieClip();
		Mouse.removeListener(CursorManager);
	}
	
	public static function isCustomCursorShowing():Boolean{
		return (cursorMC.onEnterFrame != undefined);
	}
	
	public static function getShowingCursorImage():Image{
		return cursorImage;
	}
	
	public static function showSystemCursor():Void{
		Mouse.show();
	}
	
	public static function hideSystemCursor():Void{
		Mouse.hide();
	}
	
	private static function onMouseMove():Void{
		onEnterFrame();
	}
	
	private static function onEnterFrame():Void{
		DepthManager.bringToTop(cursorMC);
		cursorMC._x = cursorMC._parent._xmouse;
		cursorMC._y = cursorMC._parent._ymouse;
	}	
	
}