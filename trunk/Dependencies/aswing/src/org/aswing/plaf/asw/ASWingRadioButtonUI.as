/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.*;
import org.aswing.plaf.*;
import org.aswing.plaf.basic.*;
 
/**
 *
 * @author iiley
 */
class org.aswing.plaf.asw.ASWingRadioButtonUI extends BasicRadioButtonUI{
	/*shared instance*/
	private static var asWingRadioButtonUI:ASWingRadioButtonUI;
	
    public static function createInstance(c:Component):ComponentUI {
    	if(asWingRadioButtonUI == null){
    		asWingRadioButtonUI = new ASWingRadioButtonUI();
    	}
        return asWingRadioButtonUI;
    }
    
    public function ASWingRadioButtonUI(){
    	super();
    }	
}
