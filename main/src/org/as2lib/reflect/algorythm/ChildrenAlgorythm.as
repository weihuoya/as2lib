import org.as2lib.reflect.ReflectInfo;
import org.as2lib.reflect.PackageInfo;
import org.as2lib.reflect.ClassInfo;
import org.as2lib.reflect.Cache;
import org.as2lib.reflect.algorythm.ContentAlgorythm;
import org.as2lib.reflect.algorythm.AbstractContentAlgorythm;
import org.as2lib.data.holder.HashMap;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.ReflectUtil;

class org.as2lib.reflect.algorythm.ChildrenAlgorythm extends AbstractContentAlgorythm implements ContentAlgorythm {
	private var cache:Cache;
	private var data:HashMap;
	private var info:PackageInfo;
	private var type:String;
	
	public function ChildrenAlgorythm(cache) {
		cache = ReflectUtil.getCache();
	}
	
	public function execute(info:ReflectInfo):HashMap {
		type = null;
		
		this.info = PackageInfo(info);
		this.data = new HashMap();
		
		var package:Object = this.info.getPackage();
		search(package);
		
		return data;
	}
	
	private function validate(target, name:String):Boolean {
		if (ObjectUtil.isTypeOf(target[name], "function")) {
			type = "class";
			return true;
		}
		if (ObjectUtil.isTypeOf(target[name], "object")) {
			type = "package";
			return true;
		}
		return false;
	}
	
	private function store(name:String, target):Void {
		if (type == "class") {
			var clazz:ClassInfo = cache.getClass(target[name]);
			if (ObjectUtil.isEmpty(clazz)) {
				clazz = new ClassInfo(name, target[name], info);
				cache.addClass(clazz);
			}
			data.put(name, clazz);
			return;
		}
		if (type == "package") {
			var package:PackageInfo = cache.getPackage(target[name]);
			if (ObjectUtil.isEmpty(package)) {
				package = new PackageInfo(name, target[name], info);
				cache.addPackage(package);
			}
			data.put(name, package);
			return;
		}
	}
}