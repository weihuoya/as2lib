import com.asual.enflash.EnFlashObject;

﻿/**
 *	Tween class enables the creation of effects using Robert Penner's 
 *	<a href="http://www.robertpenner.com/easing/">Easing Equations</a>.
 */
class com.asual.enflash.effects.Tween extends EnFlashObject {

	private var _name:String = "Tween";	

	public var onchange:Function;
	public var oncomplete:Function;	

	public function Tween(id:String) {
		super(id);
	}

	public function start(object:Object, property:String, value:Number, duration:Number, easing:Function):Object {

		var tween = new Object();
		tween.object = object;
		tween.property = property;
		tween.duration = duration;
		tween.value = value;
		tween.easing = easing;
		tween.initial = object[property];
		tween.delta = tween.value - tween.initial;
		tween.start = getTimer();
		tween.interval = setInterval(this, "_tween", 80, tween);
		return tween;
	}

	public function stop(tween:Object):Void {
			clearInterval(tween.interval);
			delete this;		
	}

	private function _tween(tween:Object):Void {
		
		var time = getTimer() - tween.start;
		
		if (time >= tween.duration) {
			tween.object[tween.property] = tween.value;	
			dispatchEvent("change", tween.object, tween.property, tween.object[tween.property]);
			dispatchEvent("complete", tween.object, tween.property, tween.object[tween.property]);
			stop(tween);
		} else {
			tween.object[tween.property] = tween.easing(time, tween.initial, tween.delta, tween.duration);
			dispatchEvent("change", tween.object, tween.property, tween.object[tween.property]);
		}
	}
} 