﻿import org.as2lib.basic.BasicClass;
import org.as2lib.basic.reflect.ReflectInfo;

class org.as2lib.basic.reflect.algorythm.AbstractContentAlgorythm extends BasicClass {
	private function AbstractContentAlgorythm(Void) {
	}
	
	public function search(target:Object):Void {
		var i:String;
		for (i in target) {
			if (validate(target, i)) {
				store(i, target);
			}
		}
	}
	
	private function validate(target:Object, name:String):Boolean {
		return true;
	}
	
	private function store(name:String, target:Object):Void {
	}
}