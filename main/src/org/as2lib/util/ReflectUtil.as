import org.as2lib.basic.BasicClass;
import org.as2lib.basic.reflect.Cache;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.basic.reflect.PackageInfo;
import org.as2lib.data.Hashtable;
import org.as2lib.basic.reflect.algorythm.CacheAlgorythm;
import org.as2lib.basic.reflect.algorythm.ContentAlgorythm;
import org.as2lib.basic.reflect.algorythm.ClassAlgorythm;
import org.as2lib.basic.reflect.algorythm.SuperClassAlgorythm;
import org.as2lib.basic.reflect.algorythm.PackageAlgorythm;
import org.as2lib.basic.reflect.algorythm.MethodAlgorythm;
import org.as2lib.basic.reflect.algorythm.PropertyAlgorythm;
import org.as2lib.basic.reflect.algorythm.ChildrenAlgorythm;
import org.as2lib.util.ObjectUtil;

class org.as2lib.util.ReflectUtil extends BasicClass {
	private static var cache:Cache = new Cache();
	private static var classAlgorythm:CacheAlgorythm = new ClassAlgorythm(cache);
	private static var packageAlgorythm:CacheAlgorythm = new PackageAlgorythm(cache);
	private static var superClassAlgorythm:ContentAlgorythm = new SuperClassAlgorythm(cache);
	private static var methodAlgorythm:ContentAlgorythm = new MethodAlgorythm(cache);
	private static var propertyAlgorythm:ContentAlgorythm = new PropertyAlgorythm(cache);
	private static var childrenAlgorythm:ContentAlgorythm = new ChildrenAlgorythm(cache);
	
	private function ReflectUtil(Void) {
	}
	
	public static function getClassInfo(object:Object):ClassInfo {
		if (ObjectUtil.isEmpty(cache.getClass(object))) {
			classAlgorythm.execute(object);
		}
		return cache.getClass(object);
	}
	
	public static function getPackageInfo(object:Object):PackageInfo {
		if (ObjectUtil.isEmpty(cache.getPackage(object))) {
			packageAlgorythm.execute(object);
		}
		return cache.getPackage(object);
	}
	
	public static function getSuperClass(info:ClassInfo):ClassInfo {
		if (ObjectUtil.isEmpty(cache.getClass(info.getClass().prototype))) {
			superClassAlgorythm.execute(info);
		}
		return cache.getClass(info.getClass().prototype);
	}
	
	public static function getMethods(info:ClassInfo):Hashtable {
		return methodAlgorythm.execute(info);
	}
	
	public static function getProperties(info:ClassInfo):Hashtable {
		return propertyAlgorythm.execute(info);
	}
	
	public static function getChildren(info:PackageInfo):Hashtable {
		return childrenAlgorythm.execute(info);
	}
	
	public static function setClassAlgorythm(algorythm:CacheAlgorythm):Void {
		classAlgorythm = algorythm;
	}
	
	public static function setPackageAlgorythm(algorythm:CacheAlgorythm):Void {
		packageAlgorythm = algorythm;
	}
	
	public static function setSuperClassAlgorythm(algorythm:ContentAlgorythm):Void {
		superClassAlgorythm = algorythm;
	}
	
	public static function setMethodAlgorythm(algorythm:ContentAlgorythm):Void {
		methodAlgorythm = algorythm;
	}
	
	public static function setPropertyAlgorythm(algorythm:ContentAlgorythm):Void {
		propertyAlgorythm = algorythm;
	}
	
	public static function setChildrenAlgorythm(algorythm:ContentAlgorythm):Void {
		childrenAlgorythm = algorythm;
	}
}