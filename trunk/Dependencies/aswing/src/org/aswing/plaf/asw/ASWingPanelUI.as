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
class org.aswing.plaf.asw.ASWingPanelUI extends BasicPanelUI{
	/*shared instance*/
	private static var asWingPanelUI:ASWingPanelUI;
	
    public static function createInstance(c:Component):ComponentUI {
    	if(asWingPanelUI == null){
    		asWingPanelUI = new ASWingPanelUI();
    	}
        return asWingPanelUI;
    }
    
    public function ASWingPanelUI(){
    	super();
    }	
}
