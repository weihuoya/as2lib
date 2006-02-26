/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AwmlConstants;
import org.aswing.awml.AwmlParser;
import org.aswing.awml.component.ComponentParser;
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.LayoutManager;

/**
 * Parses {@link org.aswing.Container} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.ContainerParser extends ComponentParser {
	
	/**
	 * Private Constructor.
	 */
	private function ContainerParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, container:Container):Container {
		super.parse(awml, container);
		
		return container;
	}
	
	private function parseChild(awml:XMLNode, nodeName:String, container:Container):Void {

		super.parseChild(awml, nodeName, container);

		// TODO child components
		switch (nodeName) {
			case AwmlConstants.NODE_TEXT_AREA:
			case AwmlConstants.NODE_TEXT_FIELD:
			case AwmlConstants.NODE_SEPARATOR:
			case AwmlConstants.NODE_PROGRESS_BAR:
			case AwmlConstants.NODE_LABEL:
			case AwmlConstants.NODE_BUTTON:
			case AwmlConstants.NODE_TOGGLE_BUTTON:
			case AwmlConstants.NODE_CHECK_BOX:
			case AwmlConstants.NODE_RADIO_BUTTON:
				var component:Component = AwmlParser.parse(awml);
				if (component != null) append(container, component);	
			break;
			case AwmlConstants.NODE_EMPTY_LAYOUT:
			case AwmlConstants.NODE_FLOW_LAYOUT:
			case AwmlConstants.NODE_SOFT_BOX_LAYOUT:
			case AwmlConstants.NODE_GRID_LAYOUT:
			case AwmlConstants.NODE_BOX_LAYOUT:
			case AwmlConstants.NODE_BORDER_LAYOUT:
				var layout:LayoutManager = AwmlParser.parse(awml);
				if (layout != null) setLayout(container, layout);
			break;
		}
	}
	
	/**
	 * Appends <code>component</code> to the <code>container</code>.
	 * 
	 * @param container the container to add the component to
	 * @param component the component to add to the container 
	 */
	private function append(container:Container, component:Component):Void {
		container.append(component);
	}
	
	/**
	 * Set <code>layout</code> to the <code>container</code>.
	 * 
	 * @param container the container to set layout
	 * @param layout the layout to set 
	 */
	private function setLayout(container:Container, layout:LayoutManager):Void {
		container.setLayout(layout);
	}
	
}
