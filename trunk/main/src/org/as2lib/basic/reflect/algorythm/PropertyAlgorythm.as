import org.as2lib.basic.reflect.ReflectInfo;
import org.as2lib.basic.reflect.PropertyInfo;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.basic.reflect.Cache;
import org.as2lib.basic.reflect.algorythm.ContentAlgorythm;
import org.as2lib.basic.reflect.algorythm.AbstractContentAlgorythm;
import org.as2lib.data.holder.Hashtable;

class org.as2lib.basic.reflect.algorythm.PropertyAlgorythm extends AbstractContentAlgorythm implements ContentAlgorythm {
	private var data:Hashtable;
	private var getters:Hashtable;
	private var setters:Hashtable;
	private var staticGetters:Hashtable;
	private var staticSetters:Hashtable;
	private var info:ClassInfo;
	private var staticFlag:Boolean;
	private var type:String;
	
	public function PropertyAlgorythm(Void) {
	}
	
	public function execute(info:ReflectInfo):Hashtable {
		type = null;
		
		this.info = ClassInfo(info);
		this.data = new Hashtable();
		this.getters = new Hashtable();
		this.setters = new Hashtable();
		this.staticGetters = new Hashtable();
		this.staticSetters = new Hashtable();
		
		this.staticFlag = true;
		var clazz:Function = this.info.getClass();
		search(clazz);
		
		this.staticFlag = false;
		var prototype:Object = clazz.prototype;
		_global.ASSetPropFlags(prototype, null, 6, true);
		_global.ASSetPropFlags(prototype, ["__proto__", "constructor", "__constructor__"], 1, true);
		search(prototype);
		_global.ASSetPropFlags(prototype, null, 1, true);
		
		return data;
	}
	
	private function validate(target:Object, name:String):Boolean {
		if (typeof(prototype[name] == "function")) {
			var coreName = name.substring(7);
			if (name.indexOf("__get__") == 0) {
				getters.put(coreName, true);
				if (!setters.get(coreName)) {
					type = "__get__";
					return true;
				}
				return false;
			} 
			if (name.indexOf("__set__") == 0) {
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
	
	private function store(name:String, target:Object):Void {
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