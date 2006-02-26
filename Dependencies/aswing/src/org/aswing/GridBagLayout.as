import org.aswing.Component;
import org.aswing.Container;
import org.aswing.geom.Dimension;
import org.aswing.LayoutManager;

/**
 * @author Tomato
 */
class org.aswing.GridBagLayout implements LayoutManager {
	
	public function addLayoutComponent(comp : Component, constraints : Object) : Void {
	}

	public function removeLayoutComponent(comp : Component) : Void {
	}

	public function preferredLayoutSize(target : Container) : Dimension {
		return null;
	}

	public function minimumLayoutSize(target : Container) : Dimension {
		return null;
	}

	public function maximumLayoutSize(target : Container) : Dimension {
		return null;
	}

	public function layoutContainer(target : Container) : Void {
	}

	public function getLayoutAlignmentX(target : Container) : Number {
		return null;
	}

	public function getLayoutAlignmentY(target : Container) : Number {
		return null;
	}

	public function invalidateLayout(target : Container) : Void {
	}

}