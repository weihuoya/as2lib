/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.border.*;
import org.aswing.*;
import org.aswing.plaf.*;
 
/**
 * @author iiley
 */
class org.aswing.plaf.basic.border.ScrollPaneBorder extends LineBorder implements UIResource{	
	
	private static var instance:Border;
	
	/**
	 * this make shared instance and construct when use.
	 */	
	public static function createInstance():Border{
		if(instance == null){
			var table:UIDefaults = UIManager.getLookAndFeelDefaults();
			var color:ASColor = table.getColor("ScrollPane.darkShadow");
			instance = new ScrollPaneBorder(color);
		}
		return instance;
	}
	
	public function ScrollPaneBorder(color:ASColor){
		super(null, color, 1);
	}

}
