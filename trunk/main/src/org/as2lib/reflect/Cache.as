import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.HashMap;
import org.as2lib.reflect.ClassInfo;
import org.as2lib.reflect.PackageInfo;
import org.as2lib.reflect.RootInfo;

class org.as2lib.reflect.Cache extends BasicClass {
	private var classes:HashMap;
	private var packages:HashMap;
	private var root:RootInfo;
	
	public function Cache(Void) {
		classes = new HashMap();
		packages = new HashMap();
		root = new RootInfo("root", _global);
	}
	
	public function getClass(object):ClassInfo {
		return ClassInfo(classes.get(object.__proto__));
	}
	
	public function addClass(info:ClassInfo):ClassInfo {
		classes.put(info.getClass().prototype, info);
		return info;
	}
	
	public function getPackage(object
							   ):PackageInfo {
		return PackageInfo(packages.get(object));
	}
	
	public function addPackage(info:PackageInfo):PackageInfo {
		packages.put(info.getPackage(), info);
		return info;
	}
	
	public function getRoot(Void):RootInfo {
		return root;
	}
}