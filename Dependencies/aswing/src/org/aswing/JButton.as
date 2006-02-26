/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.*;
import org.aswing.plaf.*;
 
/**
 * 
 * @author iiley
 */
class org.aswing.JButton extends AbstractButton{
	
	/**
     * JButton(text:String, icon:Icon)<br>
     * JButton(text:String)<br>
     * JButton(icon:Icon)
     * <p>
	 */
	public function JButton(text, icon:Icon){
		super(text, icon);
		setName("JButton");
    	setModel(new DefaultButtonModel());
		updateUI();
	}
	
    public function updateUI():Void{
    	setUI(ButtonUI(UIManager.getUI(this)));
    }
	
	public function getUIClassID():String{
		return "ButtonUI";
	}
}
