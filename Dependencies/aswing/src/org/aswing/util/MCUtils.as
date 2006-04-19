/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.geom.Point;

/**
 * Utils functions about MovieClip
 * @author iiley
 */
class org.aswing.util.MCUtils{
		
	/**
	 * Transform the position in fromMC to toMC and return it.
	 */
	public static function locationTrans(fromMC:MovieClip, toMC:MovieClip, p:Point):Point{
		fromMC.localToGlobal(p);
		toMC.globalToLocal(p);
		return p;
	}
	
	/**
	 * Returns is the MovieClip is exist.
	 */
	public static function isMovieClipExist(mc:MovieClip):Boolean{
		return mc != undefined && mc._totalframes != undefined;
	}
	
	/**
	 * Returns is the MovieClip is exist.
	 */
	public static function isTextFieldExist(tf:TextField):Boolean{
		return tf != undefined && tf._height != undefined;
	}
}
