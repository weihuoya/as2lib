import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.env.reflect.MethodInfo;
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
class org.as2lib.env.reflect.algorythm.MethodAlgorythm extends AbstractContentAlgorythm implements ContentAlgorythm {
	private var data:Map;
	private var info:ClassInfo;
	private var staticFlag:Boolean;
	
	public function MethodAlgorythm(Void) {
	}
	
	public function execute(info:CacheInfo):Map {
		this.info = ClassInfo(info);
		this.data = new HashMap();
		
		this.staticFlag = true;
		var clazz:Function = this.info.getClass();
		search(clazz);
		
		this.staticFlag = false;
		ObjectUtil.setAccessPermission(clazz.prototype, ObjectUtil.ACCESS_ALL_ALLOWED);
		_global.ASSetPropFlags(clazz.prototype, ["__proto__", "constructor", "__constructor__"], 1, true);
		search(clazz.prototype);
		_global.ASSetPropFlags(clazz.prototype, null, 1, true);
		
		return data;
	}
	
	private function validate(target, name:String):Boolean {
		if (ObjectUtil.isTypeOf(target[name], "function")) {
			if (!StringUtil.startsWith(name, "__get__")
					&& !StringUtil.startsWith(name, "__set__")) {
				return true;
			}
		}
		return false;
	}
	
	private function store(name:String, target):Void {
		var method:MethodInfo = new MethodInfo(name, target[name], info, staticFlag);
		data.put(name, method);
	}
}