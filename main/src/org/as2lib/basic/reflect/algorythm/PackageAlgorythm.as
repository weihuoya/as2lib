import org.as2lib.basic.BasicClass;
import org.as2lib.basic.reflect.algorythm.CacheAlgorythm;
import org.as2lib.basic.reflect.Cache;
import org.as2lib.basic.reflect.PackageInfo;
import org.as2lib.util.ObjectUtil;

class org.as2lib.basic.reflect.algorythm.PackageAlgorythm extends BasicClass implements CacheAlgorythm {
	private var cache:Cache;
	
	public function PackageAlgorythm(cache:Cache) {
		this.cache = cache;
	}
	
	public function execute(object:Object):Void {
		findAndStore(cache.getRoot(), object);
	}
	
	public function findAndStore(info:PackageInfo, object:Object):Boolean {
		var package:Object = info.getPackage();
		var i:String;
		for (i in package) {
			if (ObjectUtil.isTypeOf(package[i], "object")) {
				if (executePackageLogic(i, package[i], info, object)) {
					return true;
				}
			}
		}
		return false;
	}
	
	private function executePackageLogic(name:String, package:Object, parent:PackageInfo, object:Object):Boolean {
		var sp:PackageInfo = cache.getPackage(package);
		if (ObjectUtil.isEmpty(sp)) {
			sp = storePackage(name, package, parent);
		}
		if (package == object) {
			return true;
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