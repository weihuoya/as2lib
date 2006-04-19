/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.*;
import org.aswing.plaf.*;
 
/**
 *
 * @author iiley
 */
class org.aswing.plaf.ASFontUIResource extends ASFont implements UIResource{
	
	public function ASFontUIResource(_name:String , _size:Number , _bold:Boolean , _italic:Boolean , _underline:Boolean){
		super(_name, _size, _bold, _italic , _underline);
	}
		
	public static function createResourceFont(font:ASFont):ASFontUIResource{
		return new ASFontUIResource(font.getName(), font.getSize(), font.getBold(), font.getItalic(), font.getUnderline());
	}
	
}
