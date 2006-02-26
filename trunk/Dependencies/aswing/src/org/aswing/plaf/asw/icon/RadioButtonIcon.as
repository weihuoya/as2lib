/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.*;
 
/**
 *
 * @author iiley
 */
class org.aswing.plaf.asw.icon.RadioButtonIcon extends org.aswing.plaf.basic.icon.RadioButtonIcon{
	
	private static var aswInstance:Icon;
	
	/**
	 * this make shared instance and construct when use.
	 */	
	public static function createInstance():Icon{
		if(aswInstance == null){
			aswInstance = new RadioButtonIcon();
		}
		return aswInstance;
	}

	private function RadioButtonIcon(){
		super();
	}
}
