import org.as2lib.basic.BasicClass;
import org.as2lib.basic.reflect.algorythm.CacheAlgorythm;
import org.as2lib.basic.reflect.Cache;
import org.as2lib.basic.reflect.ReflectInfo;
import org.as2lib.basic.reflect.PackageInfo;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.util.ObjectUtil;

class org.as2lib.basic.reflect.algorythm.ClassAlgorythm extends BasicClass implements CacheAlgorythm {
	private var cache:Cache;
	private var info:ClassInfo;
	
	public function ClassAlgorythm(cache:Cache) {
		this.cache = cache;
	}
	
	public function execute(object:Object):ReflectInfo {
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