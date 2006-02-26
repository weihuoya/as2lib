import org.aswing.AbstractButton;
import org.aswing.Component;
import org.aswing.Icon;
import org.aswing.JButton;
import org.aswing.plaf.basic.accordion.AccordionHeader;

/**
 * BasicAccordionHeader implemented with a JButton 
 * @author iiley
 */
class org.aswing.plaf.basic.accordion.BasicAccordionHeader implements AccordionHeader {
	
	private var button:AbstractButton;
	
	public function BasicAccordionHeader(){
		button = new JButton();
	}
	
	public function setTextAndIcon(text : String, icon : Icon) : Void {
		button.setContent(text, icon);
	}
	
	public function setSelected(b:Boolean):Void{
		//Do nothing here, if your header is selectable, you can set it here like
		//button.setSelected(b);
	}

	public function getComponent() : Component {
		return button;
	}

}