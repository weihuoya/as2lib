import org.as2lib.core.BasicClass;
import org.as2lib.reflect.Cache;
import org.as2lib.reflect.ClassInfo;
import org.as2lib.reflect.PackageInfo;
import org.as2lib.data.holder.HashMap;
import org.as2lib.util.ObjectUtil;
import org.as2lib.reflect.ReflectConfig;

/**
 * @author Simon Wacker
 * 
 * This util class offers the basic functionality to use reflections.
 * All operations are static to provide an easy external access.
 * It is not possible to instantiate the class due to its private constructor.
 */

class org.as2lib.util.ReflectUtil extends BasicClass {
	/** All classes and packages that have already been found will be cached here. */
	private static var cache:Cache = new Cache();
	
	/**
	 * The constructor is private to prevent an instantiation.
	 */
	private function ReflectUtil(Void) {
	}
	
	public static function getCache(Void):Cache {
		return cache;
	}
	
	/**
	 * This is the core operation of the class.
	 * It returns the ClassInfo instance appropriate to the Object containing all needed class information.
	 * It first checks based on the Object whether an appropriate ClassInfo instance exists.
	 * If one exists it will be returned otherwise a new will be created.
	 * The responsibility for doing this lies in the suitable CacheAlgorythm.
	 * By default this is the ClassAlgorythm. But you can set your own with the setClassAlgorythm() operation.
	 * 
	 * @param The Object the appropriate ClassInfo shall be found.
	 * @return The appropriate ClassInfo instance containing all class information.
	 */
	public static function getClassInfo(object):ClassInfo {
		var info:ClassInfo = cache.getClass(object);
		if (ObjectUtil.isEmpty(info)) {
			info = ClassInfo(ReflectConfig.getClassAlgorythm().execute(object));
		}
		return info;
	}
	
	/**
	 * This operation returns the PackageInfo instance representing the package passed in.
	 * It first checks based on the passed in Object whether an appropriate PackageInfo instance exists.
	 * If one exists it will be returned otherwise a new will be created.
	 * The responsibility for doing this lies in the suitable CacheAlgorythm.
	 * By default this is the PackageAlgorythm. But you can set your own with the setPackageAlgorythm() operation.
	 *
	 * @param The package the appropriate PackageInfo shall be found.
	 * @return The appropriate PackageInfo instance containing all package information.
	 */
	public static function getPackageInfo(package):PackageInfo {
		var info:PackageInfo = cache.getPackage(package);
		if (ObjectUtil.isEmpty(info)) {
			info = PackageInfo(ReflectConfig.getPackageAlgorythm().execute(package));
		}
		return info;
	}
	
	/**
	 * This operation returns a HashMap containing the MethodInfo instances representing the methods.
	 * The problem right now is that public and private methods are not distinguished.
	 * This is due to the impossibility of finding out (at runtime) whether the method is private or public.
	 *
	 * @param The ClassInfo instance representing the class the methods shall be searched for.
	 * @return A HashMap holding MethodInfo instances for each method.
	 */
	public static function getMethods(info:ClassInfo):HashMap {
		return ReflectConfig.getMethodAlgorythm().execute(info);
	}
	
	/** 
	 * This operation returns a HashMap containing the PropertyInfo instances representing the Properties.
	 * Properties are set in Flash MX 2004 via the set and get keyword.
	 *
	 * @param The ClassInfo instance representing the class the methods shall be searched for.
	 * @return A HashMap holding PropertyInfo instances for each property.
	 */
	public static function getProperties(info:ClassInfo):HashMap {
		return ReflectConfig.getPropertyAlgorythm().execute(info);
	}
	
	/**
	 * This operation returns the children of a package.
	 * Children can be either of type ClassInfo or PackageInfo.
	 *
	 * @param A PackageInfo instance representing the package the children shall be returned.
	 * @return A HashMap containing all children of the appropriate package.
	 */
	public static function getChildren(info:PackageInfo):HashMap {
		return ReflectConfig.getChildrenAlgorythm().execute(info);
	}
}