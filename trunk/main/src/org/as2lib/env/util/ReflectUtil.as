import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.data.holder.Map;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.NoSuchChildException;
import org.as2lib.env.overload.Overload;

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
	 * Overload
	 * #getClassInfoByObject()
	 * #getClassInfoByName()
	 */
	public static function getClassInfo():ClassInfo {
		var overload:Overload = new Overload();
		overload.addHandler([Object], getClassInfoByObject);
		overload.addHandler([String], getClassInfoByName);
		return ClassInfo(overload.forward(arguments));
	}
	
	/**
	 * Returns the ClassInfo appropriate to the object containing all needed
	 * class information.
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
	public static function getClassInfoByObject(object):ClassInfo {
		var info:ClassInfo = ReflectConfig.getCache().getClass(object);
		if (ObjectUtil.isEmpty(info)) {
			info = ClassInfo(ReflectConfig.getClassAlgorythm().execute(object));
			ReflectConfig.getCache().addClass(info);
		}
		return info;
	}
	
	/**
	 * Returns the ClassInfo corresponding to the passed name. The name must
	 * be composed of the class's path as well as its name.
	 *
	 * @param name the full name of the class
	 * @return a ClassInfo representing the class corresponding to the name
	 * @throws org.as2lib.env.reflect.NoSuchChildException if the class with the specified name does not exist
	 */
	public static function getClassInfoByName(name:String):ClassInfo {
		var path:Array = name.split(".");
		var member = _global;
		for (var i:Number = 0; i < path.length; i++) {
			member = member[path[i]];
		}
		if (ObjectUtil.isTypeOf(member, "function")) {
			return getClassInfoByObject(member);
		}
		throw new NoSuchChildException("The class [" + name + "] you tried to obtain does not exist.",
										eval("th" + "is"),
										arguments);
	}
	
	/**
	 * Overload
	 * #getPackageInfoByPackage()
	 * #getPackageInfoByName()
	 */
	public static function getPackageInfo():PackageInfo {
		var overload:Overload = new Overload();
		overload.addHandler([Object], getPackageInfoByPackage);
		overload.addHandler([String], getPackageInfoByName);
		return PackageInfo(overload.forward(arguments));
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
	public static function getPackageInfoByPackage(package):PackageInfo {
		var info:PackageInfo = ReflectConfig.getCache().getPackage(package);
		if (ObjectUtil.isEmpty(info)) {
			info = PackageInfo(ReflectConfig.getPackageAlgorythm().execute(package));
			ReflectConfig.getCache().addPackage(info);
		}
		return info;
	}
	
	/**
	 * Returns the PackageInfo corresponding to the passed name. The name must
	 * be composed of the package's path as well as its name.
	 *
	 * @param name the full name of the package
	 * @return a PackageInfo representing the package corresponding to the name
	 * @throws org.as2lib.env.reflect.NoSuchChildException if the package with the specified name does not exist
	 */
	public static function getPackageInfoByName(name:String):PackageInfo {
		var path:Array = name.split(".");
		var member = _global;
		for (var i:Number = 0; i < path.length; i++) {
			member = member[path[i]];
		}
		if (ObjectUtil.isTypeOf(member, "object")) {
			return getPackageInfoByPackage(member);
		}
		throw new NoSuchChildException("The package [" + name + "] you tried to obtain does not exist.",
										eval("th" + "is"),
										arguments);
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