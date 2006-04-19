/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.*;
import org.aswing.plaf.*;
 
/**
 *
 * @author iiley
 */
class org.aswing.plaf.ASColorUIResource extends ASColor implements UIResource{
	
	public function ASColorUIResource(rgb:Number, alpha:Number){
		super(rgb, alpha);
	}
	
	public static function createResourceColor(color:ASColor):ASColorUIResource{
		return new ASColorUIResource(color.getRGB(), color.getAlpha());
	}
}
