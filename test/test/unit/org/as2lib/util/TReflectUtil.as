import org.as2lib.test.unit.Test;
import test.org.as2lib.util.treflectutil.SubClass;
import test.org.as2lib.util.treflectutil.SuperClass;
import org.as2lib.util.ReflectUtil;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.basic.reflect.PackageInfo;

class test.org.as2lib.util.TReflectUtil extends Test {
	private var sub:SubClass;
	private var sup:SuperClass;
	
	private var subInfo:ClassInfo;
	private var superInfo:ClassInfo;
	
	private var package:Object;
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
		trace (subInfo === getClassInfo(sub));
		trace (superInfo === subInfo.getSuperClass());
	}
	public function testGetPackageInfo(Void):Void {
		trace (packageInfo === getPackageInfo(package));
		trace (packageInfo === subInfo.getParent());
		
	}
	
	private function getClassInfo(object:Object):ClassInfo {
		return ReflectUtil.getClassInfo(object);
	}
	private function getPackageInfo(package:Object):PackageInfo {
		return ReflectUtil.getPackageInfo(package);
	}
}