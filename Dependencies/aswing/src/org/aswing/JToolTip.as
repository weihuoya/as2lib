/*
 Copyright aswing.org, see the LICENCE.txt.
*/
import org.aswing.ASWingUtils;
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.EmptyLayout;
import org.aswing.geom.Dimension;
import org.aswing.geom.Point;
import org.aswing.geom.Rectangle;
import org.aswing.MCPanel;
import org.aswing.plaf.ToolTipUI;
import org.aswing.UIManager;
import org.aswing.util.Delegate;
import org.aswing.util.DepthManager;
import org.aswing.util.Timer;

/**
 *
 * @author iiley
 */
class org.aswing.JToolTip extends Container {
	
	/**
	 * When the tip text changed.
	 *<br>
	 * onTipTextChanged(source:JTextComponent)
	 */	
	public static var ON_TIP_TEXT_CHANGED :String = "onTipTextChanged";
	
	
	//the time waiting after to view tool tip when roll over a component
	private static var WAIT_TIME:Number = 600;
	//when there is one tooltip is just shown, next will shown fast as this time
	private static var FAST_OCCUR_TIME:Number = 50;
	
	private static var last_tip_dropped_time:Number = 0;
	
	private static var mcPane:MCPanel;
	
	private var tipText:String;
	private var comp:Component;
	private var offsets:Point;
	private var offsetsRelatedToMouse:Boolean;
	
	private var compListener:Object;
	private var mouseMovedListener:Object;
	private var timer:Timer;
	
	public function JToolTip() {
		super();
		setName("JToolTip");
		offsets = new Point(4, 20);
		offsetsRelatedToMouse = true;
		
		compListener = new Object();
		compListener[Component.ON_ROLLOVER] = Delegate.create(this, __compRollOver);
		compListener[Component.ON_ROLLOUT] = Delegate.create(this, __compRollOut);
		compListener[Component.ON_HIDDEN] = compListener[Component.ON_ROLLOUT];
		compListener[Component.ON_DESTROY] = compListener[Component.ON_ROLLOUT];
		compListener[Component.ON_PRESS] = compListener[Component.ON_ROLLOUT];
		
		mouseMovedListener = new Object();
		mouseMovedListener.onMouseMove = Delegate.create(this, __onMouseMoved);
		
		timer = new Timer(Number.POSITIVE_INFINITY);
		timer.setRepeats(false);
		timer.setInitialDelay(WAIT_TIME);
		timer.addActionListener(__timeOnAction, this);
		
		if(mcPane == undefined){
			mcPane = new MCPanel(ASWingUtils.getRootMovieClip(), 10000, 10000);
			mcPane.setLayout(new EmptyLayout());
		}
		
		updateUI();
	}
	
	private function __compRollOver(source:Component):Void{
		if(source == comp){
			if(getTimer() - last_tip_dropped_time < FAST_OCCUR_TIME){
				timer.setInitialDelay(FAST_OCCUR_TIME);
			}else{
				timer.setInitialDelay(WAIT_TIME);
			}
			timer.start();
			Mouse.addListener(mouseMovedListener);
		}
	}
	
	private function __compRollOut(source:Component):Void{
		if(source == comp){
			timer.stop();
			Mouse.removeListener(mouseMovedListener);
			disposeToolTip();
			last_tip_dropped_time = getTimer();
		}
	}
	
	private function __onMouseMoved():Void{
		if(timer.isRunning()){
			timer.restart();
		}
	}
	
	private function __timeOnAction():Void{
		timer.stop();
		disposeToolTip();
		viewToolTip();
	}
	
	/**
	 * view the tool tip on stage
	 */
	private function viewToolTip():Void{
		mcPane.append(this);
		var paneMC:MovieClip = mcPane.getPanelMC();
		var p:Point = new Point();
		
		var relatePoint:Point = new Point();
		if(offsetsRelatedToMouse){
			relatePoint.setLocation(paneMC._xmouse, paneMC._ymouse);
		}else{
			relatePoint.setLocation(comp.componentToGlobal());
			paneMC.globalToLocal(p);
		}
		p.setLocation(relatePoint);
		p.move(offsets.x, offsets.y);
		
		var globalPos:Point = mcPane.componentToGlobal(p);
		var viewSize:Dimension = getPreferredSize();
		var visibleBounds:Rectangle = ASWingUtils.getVisibleMaximizedBounds(root_mc._parent);
		
		if(globalPos.x + viewSize.width > visibleBounds.x + visibleBounds.width){
			globalPos.x = visibleBounds.x + visibleBounds.width - viewSize.width;
		}
		if(globalPos.y + viewSize.height > visibleBounds.y + visibleBounds.height){
			globalPos.y = visibleBounds.y + visibleBounds.height - viewSize.height;
		}
		if(globalPos.x < visibleBounds.x){
			globalPos.x = visibleBounds.x;
		}
		if(globalPos.y < visibleBounds.y){
			globalPos.y = visibleBounds.y;
		}
		
		setGlobalLocation(globalPos);
		setSize(viewSize);
		DepthManager.bringToTop(root_mc);
	}
	
	private function disposeToolTip():Void{
		removeFromContainer();
	}
	
    public function updateUI():Void{
    	setUI(ToolTipUI(UIManager.getUI(this)));
    }
    
    public function setUI(newUI:ToolTipUI):Void{
    	super.setUI(newUI);
    }
	
	public function getUIClassID():String{
		return "ToolTipUI";
	}
		
	/**
	 * Sets the text to show when the tool tip is displayed. 
	 * The string tipText may be null.
	 * @param t the String to display
	 */
	public function setTipText(t:String):Void{
		if(t != tipText){
			tipText = t;
			dispatchEvent(createEventObj(ON_TIP_TEXT_CHANGED));
			repaint();
			revalidate();
		}
	}
	
	/**
	 * Returns the text that is shown when the tool tip is displayed. 
	 * The returned value may be null. 
	 * @return the string that displayed.
	 */
	public function getTipText():String{
		return tipText;
	}
	
	/**
	 * Specifies the component that the tooltip describes. 
	 * The component c may be null and will have no effect. 
	 * @param the JComponent being described
	 */
	public function setComponent(c:Component):Void{
		if(c != comp){
			comp.removeEventListener(compListener);
			comp = c;
			comp.addEventListener(compListener);
		}
	}
	
	/**
	 * Returns the component the tooltip applies to. 
	 * The returned value may be null. 
	 * @return the component that the tooltip describes
	 */
	public function getComponent():Component{
		return comp;
	}
	
	/**
	 * Sets the offsets of the tooltip related the described component.
	 * @param o the offsets point, delta x is o.x, delta y is o.y
	 */
	public function setOffsets(o:Point):Void{
		offsets.setLocation(o);
	}
	
	/**
	 * Returns the offsets of the tooltip related the described component.
	 * @return the offsets point, delta x is o.x, delta y is o.y
	 */	
	public function getOffsets():Point{
		return new Point(offsets);
	}
	
	/**
	 * Sets whether the <code>offsets</code> is related the mouse position, otherwise 
	 * it will be related the described component position.
	 * <p>
	 * This change will be taked effect at the next showing, current showing will no be changed.
	 * @param b whether the <code>offsets</code> is related the mouse position
	 */
	public function setOffsetsRelatedToMouse(b:Boolean):Void{
		offsetsRelatedToMouse = b;
	}
	
	/**
	 * Returns whether the <code>offsets</code> is related the mouse position.
	 * @return whether the <code>offsets</code> is related the mouse position
	 * @see #setOffsetsRelatedToMouse()
	 */
	public function isOffsetsRelatedToMouse():Boolean{
		return offsetsRelatedToMouse;
	}

}
