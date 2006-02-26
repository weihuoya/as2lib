/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.*;

/**
 * @author iiley
 */
class org.aswing.plaf.asw.icon.CheckBoxIcon extends org.aswing.plaf.basic.icon.CheckBoxIcon{
	private static var aswInstance:Icon;
	/**
	 * this make shared instance and construct when use.
	 */	
	public static function createInstance():Icon{
		if(aswInstance == null){
			aswInstance = new CheckBoxIcon();
		}
		return aswInstance;
	}

	private function CheckBoxIcon(){
		super();
	}
}
