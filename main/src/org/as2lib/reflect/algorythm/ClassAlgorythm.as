import org.as2lib.core.BasicClass;
import org.as2lib.reflect.algorythm.CacheAlgorythm;
import org.as2lib.reflect.Cache;
import org.as2lib.reflect.ReflectInfo;
import org.as2lib.reflect.PackageInfo;
import org.as2lib.reflect.ClassInfo;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.ReflectUtil;

class org.as2lib.reflect.algorythm.ClassAlgorythm extends BasicClass implements CacheAlgorythm {
	private var cache:Cache;
	private var info:ClassInfo;
	
	public function ClassAlgorythm() {
		cache = ReflectUtil.getCache();
	}
	
	public function execute(object:Object):ReflectInfo {
		info = null;
		findAndStore(cache.getRoot(), object);
		return info;
	}
	
	public function findAndStore(info:PackageInfo, object:Object):Boolean {
		var package:Object = info.getPackage();
		var i:String;
		for (i in package) {
			if (typeof(package[i]) == "function") {
				if (executeClassLogic(i, package[i], info, object)) {
					return true;
				}
			} else if (typeof(package[i]) == "object") {
				if (executePackageLogic(i, package[i], info, object)) {
					return true;
				}
			}
		}
		return false;
	}
	
	private function executeClassLogic(name:String, clazz:Function, parent:PackageInfo, object:Object):Boolean {
		if (object.__proto__ == clazz.prototype) {
			storeClass(name, clazz, parent);
			return true;
		}
		return false;
	}
	
	private function storeClass(name:String, clazz:Function, parent:PackageInfo):Void {
		info = new ClassInfo(name, clazz, parent)
		cache.addClass(info);
	}
	
	private function executePackageLogic(name:String, package:Object, parent:PackageInfo, object:Object):Boolean {
		var sp:PackageInfo = cache.getPackage(package);
		if (ObjectUtil.isEmpty(sp)) {
			sp = storePackage(name, package, parent);
		}
		if (findAndStore(sp, object)) {
			return true;
		}
		return false;
	}
	
	private function storePackage(name:String, package:Object, parent:PackageInfo):PackageInfo {
		return cache.addPackage(new PackageInfo(name, package, parent));
	}
}