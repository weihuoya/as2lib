import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.algorythm.CacheAlgorythm;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.ReferenceNotFoundException;

/**
 * ClassAlgorythm searches for the class of a specific instance and returns a
 * ClassInfo representing the found class.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorythm.ClassAlgorythm extends BasicClass implements CacheAlgorythm {
	private var cache:Cache;
	private var info:ClassInfo;
	
	public function ClassAlgorythm(Void) {
	}
	
	public function execute(object):CacheInfo {
		cache = ReflectConfig.getCache();
		info = null;
		findAndStore(cache.getRoot(), object);
		if (ObjectUtil.isEmpty(info)) {
			throw new ReferenceNotFoundException("The class corresponding to the instance [" + object + "] could not be found.",
												 this,
												 arguments);
		}
		return info;
	}
	
	public function findAndStore(info:PackageInfo, object):Boolean {
		var package = info.getPackage();
		var i:String;
		for (i in package) {
			if (ObjectUtil.isTypeOf(package[i], "function")) {
				if (executeClassLogic(i, package[i], info, object)) {
					return true;
				}
			} else if (ObjectUtil.isTypeOf(package[i], "object")) {
				if (executePackageLogic(i, package[i], info, object)) {
					return true;
				}
			}
		}
		return false;
	}
	
	private function executeClassLogic(name:String, clazz:Function, parent:PackageInfo, object):Boolean {
		if (object.__proto__ == clazz.prototype) {
			storeClass(name, clazz, parent);
			return true;
		}
		if (object.prototype == clazz.prototype) {
			storeClass(name, clazz, parent);
			return true;
		}
		return false;
	}
	
	private function storeClass(name:String, clazz:Function, parent:PackageInfo):Void {
		info = new ClassInfo(name, clazz, parent)
	}
	
	private function executePackageLogic(name:String, package, parent:PackageInfo, object):Boolean {
		var sp:PackageInfo = cache.getPackage(package);
		if (ObjectUtil.isEmpty(sp)) {
			sp = storePackage(name, package, parent);
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