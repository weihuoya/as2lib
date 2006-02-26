import org.aswing.Component;
import org.aswing.Icon;

/**
 * Accordion Header
 * @author iiley
 */
interface org.aswing.plaf.basic.accordion.AccordionHeader {
	
	/**
	 * Sets text and icon to the header
	 */
	public function setTextAndIcon(text:String, icon:Icon):Void;
	
	/**
	 * Sets whether it is selected
	 */
	public function setSelected(b:Boolean):Void;
	
	/**
	 * The component represent the header and can fire the selection event 
	 * through ON_RELEASE event, and focused the accordion when ON_PRESS.<p>
	 * To ensure the accordion will be focused when the header component was 
	 * pressed, so the component will be set to not focusable.
	 */
	public function getComponent():Component;
}