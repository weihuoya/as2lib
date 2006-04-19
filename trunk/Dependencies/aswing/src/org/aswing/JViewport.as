/*
 Copyright aswing.org, see the LICENCE.txt.
*/
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.geom.Dimension;
import org.aswing.geom.Point;
import org.aswing.geom.Rectangle;
import org.aswing.LayoutManager;
import org.aswing.plaf.ViewportUI;
import org.aswing.RepaintManager;
import org.aswing.UIManager;
import org.aswing.Viewportable;
import org.aswing.ViewportLayout;


/**
 *
 * @author iiley
 */
class org.aswing.JViewport extends Container implements Viewportable {
				
	/**
	 * When the viewport's state changed.
	 * View position changed, view changed, all related to scroll things changed.
	 *<br>
	 * onStateChanged(source:JViewport)
	 */	
	public static var ON_STATE_CHANGED:String = "onStateChanged";//Component.ON_STATE_CHANGED; 	
 	
	private var verticalUnitIncrement:Number;
	private var verticalBlockIncrement:Number;
	private var horizontalUnitIncrement:Number;
	private var horizontalBlockIncrement:Number;
	
	private var view:Component;
	
	/**
	 * <br>
	 * JViewport(view:Component)<br>
	 * JViewport()<br>
	 */
	public function JViewport(view:Component){
		super();
		setName("JViewport");
		if(view != undefined) setView(view);
		setLayout(new ViewportLayout());
		updateUI();
	}

    
    
    public function updateUI():Void{
    	setUI(ViewportUI(UIManager.getUI(this)));
    }
    
    
    public function setUI(newUI:ViewportUI):Void{
    	super.setUI(newUI);
    }
	
	
	
	
	public function getUIClassID():String{
		return "ViewportUI";
	}	

	/**
	 * @throws Error if the layout is not a ViewportLayout
	 */
	public function setLayout(layout:LayoutManager):Void{
		if(layout instanceof ViewportLayout){
			super.setLayout(layout);
		}else{
			trace(this + " Only on set ViewportLayout to JViewport");
			throw new Error(this + " Only on set ViewportLayout to JViewport");
		}
	}
	
	
	/**
	 * Sets the view component.<br>
	 * 
	 * <p>The view is the visible content of the JViewPort.
	 * 
	 * <p>JViewport use to manage the scroll view of a component.
	 * the component will be set size to its preferred size, then scroll in the viewport.<br>
	 * 
	 * <p>If the component's isTracksViewportWidth method is defined and return true,
	 * when the viewport's show size is larger than the component's,
	 * the component will be widen to the show size, otherwise, not widen.
	 * Same as isTracksViewportHeight method.
	 */
	public function setView(view:Component):Void{
		if(this.view != view){
			this.view = view;
			removeAll();
			
			if(view != null){
				super.insert(-1, view);
			}
			fireStateChanged();
		}
	}
	
	public function getView():Component{
		return view;
	}
		
	/**
	 * Sets the unit value for the Vertical scrolling.
	 */
    public function setVerticalUnitIncrement(increment:Number):Void{
    	if(verticalUnitIncrement != increment){
    		verticalUnitIncrement = increment;
			fireStateChanged();
    	}
    }
    
    /**
     * Sets the block value for the Vertical scrolling.
     */
    public function setVerticalBlockIncrement(increment:Number):Void{
    	if(verticalBlockIncrement != increment){
    		verticalBlockIncrement = increment;
			fireStateChanged();
    	}
    }
    
	/**
	 * Sets the unit value for the Horizontal scrolling.
	 */
    public function setHorizontalUnitIncrement(increment:Number):Void{
    	if(horizontalUnitIncrement != increment){
    		horizontalUnitIncrement = increment;
			fireStateChanged();
    	}
    }
    
    /**
     * Sets the block value for the Horizontal scrolling.
     */
    public function setHorizontalBlockIncrement(increment:Number):Void{
    	if(horizontalBlockIncrement != increment){
    		horizontalBlockIncrement = increment;
			fireStateChanged();
    	}
    }		
			
	
	/**
	 * In fact just call setView(com) in this method
	 * @see #setView()
	 */
	public function append(com:Component, constraints:Object):Void{
		setView(com);
	}
	
	/**
	 * In fact just call setView(com) in this method
	 * @see #setView()
	 */	
	public function insert(i:Number, com:Component, constraints:Object):Void{
		setView(com);
	}	
	
	//--------------------implementatcion of Viewportable---------------

	/**
	 * Returns the unit value for the Vertical scrolling.
	 */
    public function getVerticalUnitIncrement():Number{
    	if(verticalUnitIncrement != undefined){
    		return verticalUnitIncrement;
    	}else{
    		return 1;
    	}
    }
    
    /**
     * Return the block value for the Vertical scrolling.
     */
    public function getVerticalBlockIncrement():Number{
    	if(verticalBlockIncrement != undefined){
    		return verticalBlockIncrement;
    	}else{
    		return getExtentSize().height-1;
    	}
    }
    
	/**
	 * Returns the unit value for the Horizontal scrolling.
	 */
    public function getHorizontalUnitIncrement():Number{
    	if(horizontalUnitIncrement != undefined){
    		return horizontalUnitIncrement;
    	}else{
    		return 1;
    	}
    }
    
    /**
     * Return the block value for the Horizontal scrolling.
     */
    public function getHorizontalBlockIncrement():Number{
    	if(horizontalBlockIncrement != undefined){
    		return horizontalBlockIncrement;
    	}else{
    		return getExtentSize().width - 1;
    	}
    }
    
    public function setViewportTestSize(s:Dimension):Void{
    	setSize(s);
    }

	public function getExtentSize() : Dimension {
		return getInsets().inroundsSize(getSize());
	}
	
	/**
     * Usually the view's preffered size.
     * @return the view's size, (0, 0) if view is null.
	 */
	public function getViewSize() : Dimension {
		if(view == null){
			return new Dimension();
		}else{
			return view.getPreferredSize();
		}
	}
	
	/**
	 * Returns the view's position, if there is not any view, return null.
	 * @return the view's position, null if view is null.
	 */
	public function getViewPosition() : Point {
		if(view != null){
			var p:Point = view.getLocation();
			var ir:Rectangle = getInsets().getInsideBounds(getSize().getBounds());
			p.x = ir.x - p.x;
			p.y = ir.y - p.y;
			return p;
		}else{
			return null;
		}
	}

	public function setViewPosition(p : Point) : Void {
		restrictionViewPos(p);
		if(!p.equals(getViewPosition())){
			var ir:Rectangle = getInsets().getInsideBounds(getSize().getBounds());
			view.setLocation(ir.x-p.x, ir.y-p.y);
			RepaintManager.getInstance().addInvalidRootComponent(view);
			fireStateChanged();
		}
	}

	public function scrollRectToVisible(contentRect : Rectangle) : Void {
		setViewPosition(new Point(contentRect.x, contentRect.y));
	}
	
	/**
	 * Scrolls to view bottom left content. 
	 * This will make the scrollbars of <code>JScrollPane</code> scrolled automatically, 
	 * if it is located in a <code>JScrollPane</code>.
	 */
	public function scrollToBottomLeft():Void{
		setViewPosition(new Point(0, Number.MAX_VALUE));
	}
	/**
	 * Scrolls to view bottom right content. 
	 * This will make the scrollbars of <code>JScrollPane</code> scrolled automatically, 
	 * if it is located in a <code>JScrollPane</code>.
	 */	
	public function scrollToBottomRight():Void{
		setViewPosition(new Point(Number.MAX_VALUE, Number.MAX_VALUE));
	}
	/**
	 * Scrolls to view top left content. 
	 * This will make the scrollbars of <code>JScrollPane</code> scrolled automatically, 
	 * if it is located in a <code>JScrollPane</code>.
	 */	
	public function scrollToTopLeft():Void{
		setViewPosition(new Point(0, 0));
	}
	/**
	 * Scrolls to view to right content. 
	 * This will make the scrollbars of <code>JScrollPane</code> scrolled automatically, 
	 * if it is located in a <code>JScrollPane</code>.
	 */	
	public function scrollToTopRight():Void{
		setViewPosition(new Point(Number.MAX_VALUE, 0));
	}
	
	private function restrictionViewPos(p:Point):Point{
		var maxPos:Point = getViewMaxPos();
		p.x = Math.max(0, Math.min(maxPos.x, p.x));
		p.y = Math.max(0, Math.min(maxPos.y, p.y));
		return p;
	}
	
	private function getViewMaxPos():Point{
		var showSize:Dimension = getExtentSize();
		var viewSize:Dimension = getViewSize();
		var p:Point = new Point(viewSize.width-showSize.width, viewSize.height-showSize.height);
		if(p.x < 0) p.x = 0;
		if(p.y < 0) p.y = 0;
		return p;
	}
	
    /**
     * Converts a size in screen pixel coordinates to view ligic coordinates.
     * Subclasses of viewport that support "logical coordinates" will override this method. 
     * 
     * @param size  a <code>Dimension</code> object using screen pixel coordinates
     * @return a <code>Dimension</code> object converted to view logic coordinates
     */
	public function toViewCoordinatesSize(size : Dimension) : Dimension {
		return new Dimension(size.width, size.height);
	}
	
    /**
     * Converts a point in screen pixel coordinates to view coordinates.
     * Subclasses of viewport that support "logical coordinates" will override this method. 
     *
     * @param p  a <code>Point</code> object using screen pixel coordinates
     * @return a <code>Point</code> object converted to view coordinates
     */
	public function toViewCoordinatesLocation(p : Point) : Point {
		return new Point(p.x, p.y);
	}
	
    /**
     * Converts a size in view logic coordinates to screen pixel coordinates.
     * Subclasses of viewport that support "logical coordinates" will override this method. 
     * 
     * @param size  a <code>Dimension</code> object using view logic coordinates
     * @return a <code>Dimension</code> object converted to screen pixel coordinates
     */
    public function toScreenCoordinatesSize(size:Dimension):Dimension{
    	return new Dimension(size.width, size.height);
    }

    /**
     * Converts a point in view logic coordinates to screen pixel coordinates.
     * Subclasses of viewport that support "logical coordinates" will override this method. 
     * 
     * @param p  a <code>Point</code> object using view logic coordinates
     * @return a <code>Point</code> object converted to screen pixel coordinates
     */
    public function toScreenCoordinatesLocation(p:Point):Point{
    	return new Point(p.x, p.y);
    }
    	
	public function addChangeListener(func:Function, obj:Object):Object{
		return addEventListener(Component.ON_STATE_CHANGED, func, obj);
	}
	
	public function getViewportPane() : Component {
		return this;
	}

}
