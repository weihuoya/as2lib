import org.as2lib.basic.BasicClass;
import org.as2lib.basic.reflect.ReflectInfo;
import org.as2lib.basic.reflect.MethodInfo;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.basic.reflect.Cache;
import org.as2lib.basic.reflect.algorythm.ContentAlgorythm;
import org.as2lib.data.Hashtable;

class org.as2lib.basic.reflect.algorythm.MethodAlgorythm extends BasicClass implements ContentAlgorythm {
	private var cache:Cache;
	
	public function MethodAlgorythm(cache:Cache) {
		this.cache = cache;
	}
	
	public function execute(info:ReflectInfo):Hashtable {
		var result:Hashtable = new Hashtable();
		var clazz:Function = ClassInfo(info).getClass();
		var prototype:Object = clazz.prototype;
		_global.ASSetPropFlags(prototype, null, 6, true);
		_global.ASSetPropFlags(prototype, ["__proto__", "constructor"], 1, true);
		var method:MethodInfo;
		var i:String;
		for (i in prototype) {
			if (typeof(prototype[i] == "function")) {
				if (i.indexOf("__get__") != 0
						&& i.indexOf("__set__") != 0) {
					result.set(i, new MethodInfo(i, prototype[i], ClassInfo(info), false));
				}
			}
		}
		for (i in clazz) {
			if (typeof(clazz[i] == "function")) {
				if (i.indexOf("__get__") != 0
						&& i.indexOf("__set__") != 0) {
					result.set(i, new MethodInfo(i, clazz[i], ClassInfo(info), true));
				}
			}
		}
		return result;
	}
}