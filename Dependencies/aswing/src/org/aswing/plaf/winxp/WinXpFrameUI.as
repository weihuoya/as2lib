/*
 Copyright aswing.org, see the LICENCE.txt.
*/
/**
 * @author firdosh
 */
 import org.aswing.*;
 import org.aswing.plaf.*;
 import org.aswing.plaf.basic.*;
 
class org.aswing.plaf.winxp.WinXpFrameUI extends BasicFrameUI{
	
	public function WinXpFrameUI() {
		super();
	}  
    public static function createInstance(c:Component):ComponentUI {
        return new WinXpFrameUI();
    }
	
}
