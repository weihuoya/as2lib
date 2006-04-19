/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.ContainerParser;
import org.aswing.Component;
import org.aswing.JWindow;
import org.aswing.LayoutManager;

/**
 * Parses {@link org.aswing.JWindow} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.WindowParser extends ContainerParser {
	
	/** Default Window's owner */
	private static var DEFAULT_OWNER:MovieClip = _root;
	
	private static var ATTR_OWNER:String = "owner";
	private static var ATTR_ACTIVE:String = "active";
	private static var ATTR_MODAL:String = "modal";
	
	/**
	 * Constructor.
	 */
	public function WindowParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, window:JWindow):JWindow {
		if (window == null) {
			//TODO add owner-id support
			var owner = evalOwner(getAttributeAsString(awml, ATTR_OWNER));
			window = new JWindow(owner);	
		}
		
		super.parse(awml, window);
		
		//TODO button groups 
		
		// set active
		window.setActive(getAttributeAsBoolean(awml,  ATTR_ACTIVE, window.isActive()));
		
		// set modal
		window.setModal(getAttributeAsBoolean(awml, ATTR_MODAL, window.isModal()));
		
		return window;
	}

	/**
	 * Eval owner object by target path.
	 * 
	 * @param target the target path to the owner object
	 * @return target object 
	 */	
	private function evalOwner(target:String) {
		var owner = eval(target);
		return (owner != null) ? owner : DEFAULT_OWNER;	
	}
	
	/**
	 * Appends <code>component</code> to the <code>window</code>.
	 * 
	 * @param window the window to add the component to
	 * @param component the component to add to the window
	 */
	private function append(window:JWindow, component:Component):Void {
		window.getContentPane().append(component);
	}
	
	/**
	 * Set <code>layout</code> to the <code>window</code>.
	 * 
	 * @param window the window to set layout
	 * @param layout the layout to set 
	 */
	private function setLayout(window:JWindow, layout:LayoutManager):Void {
		window.getContentPane().setLayout(layout);
	}
	
}
