﻿import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.algorythm.ContentAlgorythm;
import org.as2lib.env.reflect.algorythm.AbstractContentAlgorythm;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.HashMap;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.StringUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorythm.PropertyAlgorythm extends AbstractContentAlgorythm implements ContentAlgorythm {
	private var data:Map;
	private var getters:Map;
	private var setters:Map;
	private var staticGetters:Map;
	private var staticSetters:Map;
	private var info:ClassInfo;
	private var staticFlag:Boolean;
	private var type:String;
	
	public function PropertyAlgorythm(Void) {
	}
	
	public function execute(info:CacheInfo):Map {
		type = null;
		
		this.info = ClassInfo(info);
		this.data = new HashMap();
		this.getters = new HashMap();
		this.setters = new HashMap();
		this.staticGetters = new HashMap();
		this.staticSetters = new HashMap();
		
		this.staticFlag = true;
		var clazz:Function = this.info.getClass();
		search(clazz);
		this.staticFlag = false;
		var prototype = clazz.prototype;
		_global.ASSetPropFlags(prototype, null, 6, true);
		_global.ASSetPropFlags(prototype, ["__proto__", "constructor", "__constructor__"], 1, true);
		search(prototype);
		_global.ASSetPropFlags(prototype, null, 1, true);
		
		return data;
	}
	
	private function validate(target, name:String):Boolean {
		if (ObjectUtil.isTypeOf(target[name], "function")) {
			var coreName = name.substring(7);
			if (StringUtil.startsWith(name, "__get__")) {
				getters.put(coreName, true);
				if (!setters.get(coreName)) {
					type = "__get__";
					return true;
				}
				return false;
			} 
			if (StringUtil.startsWith(name, "__set__")) {
				setters.put(coreName, true);
				if (!getters.get(coreName)) {
					type = "__set__";
					return true;
				}
				return false;
			}
		}
		return false;
	}
	
	private function store(name:String, target):Void {
		var coreName = name.substring(7);
		var property:PropertyInfo;
		if (type == "__get__") {
			property = new PropertyInfo(coreName, target["__set__" + coreName], target[name], info, staticFlag);
			data.put(coreName, property);
			return;
		}
		if (type == "__set__") {
			property = new PropertyInfo(coreName, target[name], target["__get__" + coreName], info, staticFlag);
			data.put(coreName, property);
			return;
		}
	}
}