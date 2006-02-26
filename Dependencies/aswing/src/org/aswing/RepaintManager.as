﻿/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.Component;
import org.aswing.ElementCreater;
import org.aswing.EventDispatcher;
import org.aswing.util.Delegate;
import org.aswing.util.HashMap;

/**
 * RepaintManager use to manager the component's painting.
 * 
 * <p>If you want to repaint a component, call its repaint method, it will regist itself
 * to RepaintManager, when frame ended, it will call its paintImmediately to paint its.
 * So component's repaint method is fast. But it will not paint immediately, if you want to paint
 * it immediately, you should call paintImmediately method, but it is not fast.
 * @author iiley
 */
class org.aswing.RepaintManager extends EventDispatcher{
	/**
	 * When the paint time before all component painted.
	 *<br>
	 * onBeforePaint(target:RepaintManager)
	 */	
	public static var ON_BEFORE_PAINT:String = "onBeforePaint";	
		
	/**
	 * When the paint time after all component painted.
	 *<br>
	 * onAfterPaint(target:RepaintManager)
	 */	
	public static var ON_AFTER_PAINT:String = "onAfterPaint";	
	
	private static var instance:RepaintManager;
	
	private var tickerMC:MovieClip;
	/**
	 * although it's a set in fact, but it work more like a queue
	 * just one component would only located one position.(one time a component do not need more than one painting)
	 */
	private var repaintQueue:HashMap;
	/**
	 * similar to repaintQueue
	 */
	private var validateQueue:HashMap;
	
	private var afterNextTimeFuncs:Array;
	private var beforeNextTimeFuncs:Array;
	
	private function RepaintManager(){
		tickerMC = ElementCreater.getInstance().createMC(_root, "tickerMC");
		tickerMC.onEnterFrame = Delegate.create(this, tick);
		repaintQueue = new HashMap();
		validateQueue = new HashMap();
		afterNextTimeFuncs = new Array();
		beforeNextTimeFuncs = new Array();
	}
	
	public static function getInstance():RepaintManager{
		if(instance == null){
			instance = new RepaintManager();
		}
		return instance;
	}
		
	/**
	 * Set to call a function at next paint time after all component painted.
	 */
	public function addCallAfterNextPaintTime(func:Function):Void{
		afterNextTimeFuncs.push(func);
	}
	
	/**
	 * Set to call a function at next paint time before all component painted.
	 */
	public function addCallBeforeNextPaintTime(func:Function):Void{
		beforeNextTimeFuncs.push(func);
	}	
	
	/**
	 * Regist A Component need to repaint.
	 * @see org.aswing.Component#repaint()
	 */
	public function addRepaintComponent(com:Component):Void{
		repaintQueue.put(com.getID(), com);
	}
	
	/**
	 * Find the Component's validate root parent and regist it need to validate.
	 * @see org.aswing.Component#revalidate()
	 * @see org.aswing.Component#validate()
	 * @see org.aswing.Component#invalidate()
	 */	
	public function addInvalidComponent(com:Component):Void{
		var validateRoot:Component = getValidateRootComponent(com);
		if(validateRoot != null){
			validateQueue.put(validateRoot.getID(), validateRoot);
		}
	}
	
	/**
	 * If a ancestors of component has no parent or it is isValidateRoot 
	 * and it's parent are visible, then it will be the validate root component,
	 * else it has no validate root component.
	 */
	private function getValidateRootComponent(com:Component):Component{
		var validateRoot:Component = null;
		for(var i:Component = com; i!=null; i=i.getParent()){
			if(i.isValidateRoot()){
				validateRoot = i;
				break;
			}
		}
		
		var root:Component = null;
		for(var i:Component = validateRoot; i!=null; i=i.getParent()){
			if(!i.isVisible()){
				//return null;
			}
		}
		return validateRoot;
	}
	
	/**
	 * Every frame this method will be executed to invoke the painting of components needed.
	 */
	public function tick():Void{
		
		dispatchEvent(createEventObj(ON_BEFORE_PAINT));
		
		var befores:Array = beforeNextTimeFuncs;
		beforeNextTimeFuncs = new Array();
		for(var i:Number=0; i<befores.length; i++){
			befores[i]();
		}
		
		var processValidates:Array = validateQueue.values();
		//must clear here, because there maybe addRepaintComponent at below operation
		validateQueue.clear();
		for(var i:Number=0; i<processValidates.length; i++){
			var com:Component = Component(processValidates[i]);
			com.validate();
		}
		
		var processRepaints:Array = repaintQueue.values();
		//must clear here, because there maybe addInvalidComponent at below operation
		repaintQueue.clear();
		
		for(var i:Number=0; i<processRepaints.length; i++){
			var com:Component = Component(processRepaints[i]);
			com.paintImmediately();
		}
		
		var afters:Array = afterNextTimeFuncs;
		afterNextTimeFuncs = new Array();
		for(var i:Number=0; i<afters.length; i++){
			afters[i]();
		}
		
		dispatchEvent(createEventObj(ON_AFTER_PAINT));
	}
}
