import org.as2lib.test.unit.Test;
import test.org.as2lib.util.treflectutil.SubClass;
import test.org.as2lib.util.treflectutil.SuperClass;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;

class test.org.as2lib.util.TReflectUtil extends Test {
	private var sub:SubClass;
	private var sup:SuperClass;
	
	private var subInfo:ClassInfo;
	private var superInfo:ClassInfo;
	
	private var package;
	private var packageInfo:PackageInfo;
	
	public function TReflectUtil(Void) {
		sub = new SubClass();
		sup = new SuperClass();
		
		subInfo = getClassInfo(sub);
		superInfo = getClassInfo(sup);
		
		package = _global.test.org.as2lib.util.treflectutil;
		packageInfo = getPackageInfo(package);
	}
	
	public function testGetClassInfo(Void):Void {
		assertEqualsWithMessage ("Inconsitence: Subinfo is not consistent", subInfo, getClassInfo(sub));
		assertEqualsWithMessage ("Inconsitence: getSuper() does not return the correct SuperInfo", superInfo, subInfo.getSuperClass());
	}
	public function testGetPackageInfo(Void):Void {
		assertEqualsWithMessage ("Inconsitence: Packageinfo is not consistent", packageInfo, getPackageInfo(package));
		assertEqualsWithMessage ("Inconsitence: Subpackage does not return the main Package as parent Package", packageInfo, subInfo.getParent());
		
	}
	
	private function getClassInfo(object):ClassInfo {
		return ReflectUtil.getClassInfo(object);
	}
	private function getPackageInfo(package):PackageInfo {
		return ReflectUtil.getPackageInfo(package);
	}
}