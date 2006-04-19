/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AwmlConstants;
import org.aswing.awml.AwmlParser;
import org.aswing.awml.component.ComponentParser;
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.LayoutManager;
import org.aswing.awml.AwmlUtils;

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

		if (AwmlUtils.isComponentNode(nodeName)) {
			var component:Component = AwmlParser.parse(awml);
			if (component != null) append(container, component);
		} else if (AwmlUtils.isLayoutNode(nodeName)) {
			var layout:LayoutManager = AwmlParser.parse(awml);
			if (layout != null) setLayout(container, layout);
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
