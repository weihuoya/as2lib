/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.border.*;

/**
 * Through, this is same to org.aswing.plaf.basic.border.ButtonBorder, 
 * this is just a sample to show, you need implement your own Border for buttons 
 * in your LAF.
 * @author iiley
 */
class org.aswing.plaf.asw.border.ButtonBorder extends org.aswing.plaf.basic.border.ButtonBorder{
	
	private static var aswInstance:Border;
	/**
	 * this make shared instance and construct when use.
	 */	
	public static function createInstance():Border{
		if(aswInstance == null){
			aswInstance = new ButtonBorder();
		}
		return aswInstance;
	}
	
	private function ButtonBorder(){
		super();
	}
}
