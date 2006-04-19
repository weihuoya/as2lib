/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.plaf.basic.frame.Resizer;
import org.aswing.plaf.basic.frame.ResizeStrategy;
import org.aswing.util.Delegate;

/**
 * The Handler for Resizer's mc bars.
 * @author iiley
 */
class org.aswing.plaf.basic.frame.ResizeBarHandler{
	private var resizer:Resizer;
	private var mc:MovieClip;
	private var arrowRotation:Number;
	private var strategy:ResizeStrategy;
	
	public function ResizeBarHandler(resizer:Resizer, barMC:MovieClip, arrowRotation:Number, strategy:ResizeStrategy){
		this.resizer = resizer;
		mc = barMC;
		this.arrowRotation = arrowRotation;
		this.strategy = strategy;
		
		handle();
	}
	
	public static function createHandler(resizer:Resizer, barMC:MovieClip, arrowRotation:Number, strategy:ResizeStrategy):ResizeBarHandler{
		return new ResizeBarHandler(resizer, barMC, arrowRotation, strategy);
	}
	
	private function handle():Void{
		mc.onRollOver = Delegate.create(this, __onRollOver);
		mc.onRollOut = Delegate.create(this, __onRollOut);
		mc.onPress = Delegate.create(this, __onPress);
		mc.onRelease = Delegate.create(this, __onRelease);
		mc.onReleaseOutside = Delegate.create(this, __onReleaseOutside);
	}
	
	private function __onRollOver():Void{
		showArrowToMousePos();
		mc.onMouseMove = Delegate.create(this, showArrowToMousePos);
	}
	
	private function __onRollOut():Void{
		mc.onMouseMove = undefined;
		resizer.hideArrow();
	}
	
	private function __onPress():Void{
		resizer.startDragArrow();
		startResize();
		mc.onMouseMove = Delegate.create(this, resizing);
	}
	
	private function __onRelease():Void{
		resizer.stopDragArrow();
		mc.onMouseMove = undefined;
		finishResize();
	}
	
	private function __onReleaseOutside():Void{
		__onRelease();
		resizer.hideArrow();
	}
	
	private function showArrowToMousePos():Void{
		resizer.setArrowRotation(arrowRotation);
		resizer.showArrowToMousePos(arrowRotation);
	}
	
	private function startResize():Void{
		resizer.startResize(strategy);
	}
	
	private function resizing():Void{
		resizer.resizing(strategy);
	}
	
	private function finishResize():Void{
		resizer.finishResize(strategy);
	}
}
