import org.as2lib.basic.reflect.ReflectInfo;
import org.as2lib.basic.reflect.MethodInfo;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.basic.reflect.Cache;
import org.as2lib.basic.reflect.algorythm.ContentAlgorythm;
import org.as2lib.basic.reflect.algorythm.AbstractContentAlgorythm;
import org.as2lib.data.Hashtable;
import org.as2lib.util.ObjectUtil;

class org.as2lib.basic.reflect.algorythm.MethodAlgorythm extends AbstractContentAlgorythm implements ContentAlgorythm {
	private var data:Hashtable;
	private var info:ClassInfo;
	private var staticFlag:Boolean;
	
	public function MethodAlgorythm(Void) {
	}
	
	public function execute(info:ReflectInfo):Hashtable {
		this.info = ClassInfo(info);
		this.data = new Hashtable();
		
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
		if (ObjectUtil.isTypeOf(target[name], "function")) {
			if (name.indexOf("__get__") != 0
					&& name.indexOf("__set__") != 0) {
				return true;
			}
		}
		return false;
	}
	
	private function store(name:String, target:Object):Void {
		var method:MethodInfo = new MethodInfo(name, target[name], info, staticFlag);
		data.set(name, method);
	}
}