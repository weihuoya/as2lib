/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.Container;
import org.aswing.FlowLayout;
import org.aswing.geom.Dimension;
import org.aswing.LayoutManager;

/**
 * @author iiley
 */
class org.aswing.plaf.basic.frame.TitleBarLayout extends FlowLayout {
	
	private static var ICON_TITLE_WIDTH:Number = 60;
	private static var ICON_TITLE_HEIGHT:Number = 20;
	
	//shared instance
	private static var instance:LayoutManager;
	public static function createInstance():LayoutManager{
		if(instance == null){
			instance = new TitleBarLayout();
		}
		return instance;
	}
	
	public function TitleBarLayout() {
		super(FlowLayout.RIGHT, 4, 4);
	}
	
	public function getHorizontalGap():Number{
		return getHgap();
	}
	
	private function fitSize(size:Dimension):Dimension{
    	size.change(ICON_TITLE_WIDTH, 0);
    	size.height = Math.max(size.height, ICON_TITLE_HEIGHT);
    	return size;
	}

    public function preferredLayoutSize(target:Container):Dimension{
    	return fitSize(super.preferredLayoutSize(target));
    }

    public function minimumLayoutSize(target:Container):Dimension{
    	return fitSize(super.preferredLayoutSize(target));
    }
}
