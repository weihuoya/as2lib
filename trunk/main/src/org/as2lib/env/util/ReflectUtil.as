import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.data.holder.Map;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.reflect.ReflectConfig;

/**
 * This util class offers the basic functionality to use reflections. All operations
 * are static to provide an easy external access. It is not possible to instantiate
 * the class due to its private constructor.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.util.ReflectUtil extends BasicClass {
	/**
	 * The constructor is private to prevent instantiation.
	 */
	private function ReflectUtil(Void) {
	}
	
	/**
	 * This is the core operation of the class. It returns the ClassInfo
	 * appropriate to the object containing all needed class information.
	 * It first checks based on the object whether an appropriate ClassInfo
	 * exists. If one exists it will be returned otherwise a new will be created.
	 * The responsibility for doing this lies in the suitable CacheAlgorythm.
	 * By default this is the ClassAlgorythm. But you can set your own with the
	 * ReflectConfig#setClassAlgorythm() operation.
	 * 
	 * @param object the object the appropriate ClassInfo shall be found.
	 * @return the appropriate ClassInfo instance containing all class information
	 * @throws IllegalArgumentException if the passed in object is neither of type function nor object
	 */
	public static function getClassInfo(object):ClassInfo {
		var info:ClassInfo = ReflectConfig.getCache().getClass(object);
		if (ObjectUtil.isEmpty(info)) {
			info = ClassInfo(ReflectConfig.getClassAlgorythm().execute(object));
			ReflectConfig.getCache().addClass(info);
		}
		return info;
	}
	
	/**
	 * This operation returns the PackageInfo instance representing the package
	 * passed in. It first checks based on the passed in package whether an
	 * appropriate PackageInfo exists. If one exists it will be returned otherwise
	 * a new will be created. The responsibility for doing this lies in the
	 * suitable CacheAlgorythm. By default this is the PackageAlgorythm. But you
	 * can set your own with the ReflectConfig#setPackageAlgorythm() operation.
	 *
	 * @param package the package the appropriate PackageInfo shall be found.
	 * @return the appropriate PackageInfo instance containing all package information.
	 */
	public static function getPackageInfo(package):PackageInfo {
		var info:PackageInfo = ReflectConfig.getCache().getPackage(package);
		if (ObjectUtil.isEmpty(info)) {
			info = PackageInfo(ReflectConfig.getPackageAlgorythm().execute(package));
			ReflectConfig.getCache().addPackage(info);
		}
		return info;
	}
	
	/**
	 * This operation returns a Map containing the MethodInfo instances
	 * representing the methods.
	 *
	 * @param info the ClassInfo instance representing the class the methods shall be searched for.
	 * @return a Map holding MethodInfos for each method.
	 */
	public static function getMethods(info:ClassInfo):Map {
		return ReflectConfig.getMethodAlgorythm().execute(info);
	}
	
	/** 
	 * This operation returns a Map containing the PropertyInfo instance
	 * representing the Properties. Properties are set in Flash MX 2004 via the
	 * set and get keyword.
	 *
	 * @param info the ClassInfo instance representing the class the properties shall be searched for.
	 * @return a Map holding PropertyInfos for each property.
	 */
	public static function getProperties(info:ClassInfo):Map {
		return ReflectConfig.getPropertyAlgorythm().execute(info);
	}
	
	/**
	 * This operation returns the children of a package. The children are of
	 * type CacheInfo.
	 *
	 * @param info a PackageInfo instance representing the package the children shall be returned for
	 * @return a Map containing all children of the appropriate package
	 */
	public static function getChildren(info:PackageInfo):Map {
		return ReflectConfig.getChildrenAlgorythm().execute(info);
	}
}