import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.algorythm.CacheAlgorythm;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.util.ReflectUtil;

class org.as2lib.env.reflect.algorythm.PackageAlgorythm extends BasicClass implements CacheAlgorythm {
	private var cache:Cache;
	private var info:PackageInfo;
	
	public function PackageAlgorythm() {
		cache = ReflectUtil.getCache();
	}
	
	public function execute(object):CacheInfo {
		info = null;
		findAndStore(cache.getRoot(), object);
		return info;
	}
	
	public function findAndStore(info:PackageInfo, object):Boolean {
		var package = info.getPackage();
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
	
	private function executePackageLogic(name:String, package, parent:PackageInfo, object):Boolean {
		var sp:PackageInfo = cache.getPackage(package);
		if (ObjectUtil.isEmpty(sp)) {
			sp = storePackage(name, package, parent);
		}
		if (package == object) {
			info = sp;
			return true;
		}
		if (findAndStore(sp, object)) {
			return true;
		}
		return false;
	}
	
	private function storePackage(name:String, package, parent:PackageInfo):PackageInfo {
		return cache.addPackage(new PackageInfo(name, package, parent));
	}
}