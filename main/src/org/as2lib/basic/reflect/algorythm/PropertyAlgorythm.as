import org.as2lib.basic.BasicClass;
import org.as2lib.basic.reflect.ReflectInfo;
import org.as2lib.basic.reflect.PropertyInfo;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.basic.reflect.Cache;
import org.as2lib.basic.reflect.algorythm.ContentAlgorythm;
import org.as2lib.data.Hashtable;

class org.as2lib.basic.reflect.algorythm.PropertyAlgorythm extends BasicClass implements ContentAlgorythm {
	private var cache:Cache;
	
	public function PropertyAlgorythm(cache:Cache) {
		this.cache = cache;
	}
	
	public function execute(info:ReflectInfo):Hashtable {
		var result:Hashtable = new Hashtable();
		var getters:Hashtable = new Hashtable();
		var setters:Hashtable = new Hashtable();
		var staticGetters:Hashtable = new Hashtable();
		var staticSetters:Hashtable = new Hashtable();
		var clazz:Function = ClassInfo(info).getClass();
		var prototype:Object = clazz.prototype;
		_global.ASSetPropFlags(prototype, null, 6, true);
		_global.ASSetPropFlags(prototype, ["__proto__", "constructor", "__constructor__"], 0, true);
		var name:String;
		var i:String;
		for (i in prototype) {
			if (typeof(prototype[i] == "function")) {
				name = i.substring(7);
				if (i.indexOf("__get__") == 0) {
					getters.set(name, true);
					if (!setters.get(name)) {
						result.set(name, new PropertyInfo(name, prototype["__set__" + name], prototype[i], ClassInfo(info), false));
					}
				} else if (i.indexOf("__set__") == 0) {
					setters.set(name, true);
					if (!getters.get(name)) {
						result.set(name, new PropertyInfo(name, prototype[i], prototype["__get__" + name], ClassInfo(info), false));
					}
				}
			}
		}
		for (i in clazz) {
			if (typeof(clazz[i] == "function")) {
				name = i.substring(7);
				if (i.indexOf("__get__") == 0) {
					staticGetters.set(name, true);
					if (!staticSetters.get(name)) {
						result.set(name, new PropertyInfo(name, clazz[i], clazz["__get__" + name], ClassInfo(info), true));
					}
				} else if (i.indexOf("__set__") == 0) {
					staticSetters.set(name, true);
					if (!staticGetters.get(name)) {
						result.set(name, new PropertyInfo(name, clazz[i], clazz["__get__" + name], ClassInfo(info), true));
					}
				}
			}
		}
		return result;
	}
}