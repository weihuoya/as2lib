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
import org.as2lib.env.reflect.SimpleCache;

/**
 * ReflectConfig is the main config used to globally configure key parts of the
 * work the classes of the reflect package try to solve.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ReflectConfig extends BasicClass {
	/** The CacheAlgorythm used to find classes. */
	private static var classAlgorythm:CacheAlgorythm = new ClassAlgorythm();
	
	/** The CacheAlgorythm used to find packages. */
	private static var packageAlgorythm:CacheAlgorythm = new PackageAlgorythm();
	
	/** The ContentAlgorythm used to find methods. */
	private static var methodAlgorythm:ContentAlgorythm = new MethodAlgorythm();
	
	/** The ContentAlgorythm used to find properties. */
	private static var propertyAlgorythm:ContentAlgorythm = new PropertyAlgorythm();
	
	/** The ContentAlgorythm used to find children. */
	private static var childrenAlgorythm:ContentAlgorythm = new ChildrenAlgorythm();
	
	/** All ClassInfos and PackageInfos that have already been found will be cached here. */
	private static var cache:Cache = new SimpleCache();
	
	/**
	 * Private constructor to prevent an instantiation.
	 */
	private function ReflectConfig(Void) {
	}
	
	/**
	 * Sets the CacheAlgorythm used to return the appropriate ClassInfo of a specific
	 * instance.
	 *
	 * @param algorythm the new CacheAlgorythm to return appropriate ClassInfos
	 */
	public static function setClassAlgorythm(algorythm:CacheAlgorythm):Void {
		classAlgorythm = algorythm;
	}
	
	/**
	 * Returns the CacheAlgorythm used to find classes and return ClassInfos 
	 * representing this classes.
	 *
	 * @return the CacheAlgorythm used to return ClassInfos
	 */
	public static function getClassAlgorythm(Void):CacheAlgorythm {
		return classAlgorythm;
	}
	
	/**
	 * Sets the CacheAlgorythm used to return the appropriate PackageInfo of a 
	 * specific instance.
	 *
	 * @param algorythm the new CacheAlgorythm to return appropriate PackageInfos
	 */
	public static function setPackageAlgorythm(algorythm:CacheAlgorythm):Void {
		packageAlgorythm = algorythm;
	}
	
	/**
	 * Returns the CacheAlgorythm used to find packages and return ClassInfos 
	 * representing this packages.
	 *
	 * @return the CacheAlgorythm used to return PackageInfos
	 */
	public static function getPackageAlgorythm(Void):CacheAlgorythm {
		return packageAlgorythm;
	}
	
	/** 
	 * Sets the ContentAlgorythm used to find and store MethodInfos representing
	 * operations of a class.
	 *
	 * @param algorythm the new ContentAlgorythm to find and store MethodInfos
	 */
	public static function setMethodAlgorythm(algorythm:ContentAlgorythm):Void {
		methodAlgorythm = algorythm;
	}
	
	/**
	 * Returns the ContentAlgorythm used to find and store MethodInfos.
	 *
	 * @return the ContentAlgorythm to find and store MethodInfos
	 */
	public static function getMethodAlgorythm(Void):ContentAlgorythm {
		return methodAlgorythm;
	}
	
	/** 
	 * Sets the ContentAlgorythm used to find and store PropertyInfos representing
	 * properties of a class.
	 *
	 * @param algorythm the new ContentAlgorythm to find and store PropertyInfos
	 */
	public static function setPropertyAlgorythm(algorythm:ContentAlgorythm):Void {
		propertyAlgorythm = algorythm;
	}
	
	/**
	 * Returns the ContentAlgorythm used to find and store PropertyInfos.
	 *
	 * @return the ContentAlgorythm to find and store PropertyInfos
	 */
	public static function getPropertyAlgorythm(Void):ContentAlgorythm {
		return propertyAlgorythm;
	}
	
	/** 
	 * Sets the ContentAlgorythm used to find and store childrens of a package.
	 *
	 * @param algorythm the new ContentAlgorythm to find and store the children
	 */
	public static function setChildrenAlgorythm(algorythm:ContentAlgorythm):Void {
		childrenAlgorythm = algorythm;
	}
	
	/**
	 * Returns the ContentAlgorythm used to find and store children.
	 *
	 * @return the ContentAlgorythm to find and store children
	 */
	public static function getChildrenAlgorythm(Void):ContentAlgorythm {
		return childrenAlgorythm;
	}
	
	/**
	 * Returns the cache used to cache all ClassInfos and PackageInfos that have
	 * already been found.
	 *
	 * @return the cache used to cache ClassInfos and PackageInfos
	 */
	public static function getCache(Void):Cache {
		return cache;
	}
	
	/**
	 * Sets the new cache used to cache ClassInfos and PackageInfos.
	 *
	 * @param cache the new cache to be used
	 */
	public static function setCache(newCache:Cache):Void {
		cache = newCache;
	}
}