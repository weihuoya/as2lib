import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.algorythm.CacheAlgorythm;
import org.as2lib.env.reflect.algorythm.ClassAlgorythm;
import org.as2lib.env.reflect.algorythm.PackageAlgorythm;
import org.as2lib.env.reflect.algorythm.ContentAlgorythm;
import org.as2lib.env.reflect.algorythm.MethodAlgorythm;
import org.as2lib.env.reflect.algorythm.PropertyAlgorythm;
import org.as2lib.env.reflect.algorythm.ChildrenAlgorythm;
import org.as2lib.data.holder.HashMap;
import org.as2lib.util.ObjectUtil;

/**
 * @author Simon Wacker
 */

class org.as2lib.env.reflect.ReflectConfig extends BasicClass {
	private static var classAlgorythm:CacheAlgorythm = new ClassAlgorythm();
	private static var packageAlgorythm:CacheAlgorythm = new PackageAlgorythm();
	private static var methodAlgorythm:ContentAlgorythm = new MethodAlgorythm();
	private static var propertyAlgorythm:ContentAlgorythm = new PropertyAlgorythm();
	private static var childrenAlgorythm:ContentAlgorythm = new ChildrenAlgorythm();
	
	/**
	 * The constructor is private to prevent an instantiation.
	 */
	private function ReflectConfig(Void) {
	}
	
	/**
	 * Sets the CacheAlgorythm used by the getClassInfo() operation.
	 */
	public static function setClassAlgorythm(algorythm:CacheAlgorythm):Void {
		classAlgorythm = algorythm;
	}
	
	public static function getClassAlgorythm(Void):CacheAlgorythm {
		return classAlgorythm;
	}
	
	/** 
	 * Sets the CacheAlgorythm used by the getPackageInfo() operation.
	 */
	public static function setPackageAlgorythm(algorythm:CacheAlgorythm):Void {
		packageAlgorythm = algorythm;
	}
	
	public static function getPackageAlgorythm(Void):CacheAlgorythm {
		return packageAlgorythm;
	}
	
	/** 
	 * Sets the ContentAlgorythm used by the getMethods() operation.
	 */
	public static function setMethodAlgorythm(algorythm:ContentAlgorythm):Void {
		methodAlgorythm = algorythm;
	}
	
	public static function getMethodAlgorythm(Void):ContentAlgorythm {
		return methodAlgorythm;
	}
	
	/** 
	 * Sets the ContentAlgorythm used by the getProperties() operation.
	 */
	public static function setPropertyAlgorythm(algorythm:ContentAlgorythm):Void {
		propertyAlgorythm = algorythm;
	}
	
	public static function getPropertyAlgorythm(Void):ContentAlgorythm {
		return propertyAlgorythm;
	}
	
	/** 
	 * Sets the ContentAlgorythm used by the getChildren() operation.
	 */
	public static function setChildrenAlgorythm(algorythm:ContentAlgorythm):Void {
		childrenAlgorythm = algorythm;
	}
	
	public static function getChildrenAlgorythm(Void):ContentAlgorythm {
		return childrenAlgorythm;
	}
}