import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.HashMap;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.RootInfo;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.reflect.Cache;

/**
 * Cache is used to cache classes and packages. The caching of classes and packages
 * leads to higher performance. You also must to cache them because for example
 * the parent of two classes residing in one package should be the same PackageInfo
 * instance.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.reflect.SimpleCache extends BasicClass implements Cache {
	/** The cached ClassInfos. */
	private var classes:Map;
	
	/** The cache PackageInfos. */
	private var packages:Map;
	
	/** The root represented by a RootInfo. */
	private var root:RootInfo;
	
	/**
	 * Constructs a new Cache instance.
	 */
	public function SimpleCache(Void) {
		classes = new HashMap();
		packages = new HashMap();
		root = RootInfo.getInstance();
	}
	
	/**
	 * Returns the ClassInfo representing either the class the object was instantiated
	 * of or the class that was passed in. If there is no corresponding ClassInfo
	 * cached nothing will be returned.
	 *
	 * @param object the instance or class the appropriate ClassInfo shall be returned
	 * @return the ClassInfo representing the class
	 * @throws IllegalArgumentException if the passed in object is neither of type function nor object
	 */
	public function getClass(object):ClassInfo {
		if (ObjectUtil.isTypeOf(object, "object")) {
			return ClassInfo(classes.get(object.__proto__));
		}
		if (ObjectUtil.isTypeOf(object, "function")) {
			return ClassInfo(classes.get(object.prototype));
		}
		throw new IllegalArgumentException("The object [" + object + "] must be either of type object or function.",
										   this,
										   arguments);
	}
	
	/**
	 * Adds a ClassInfo to the list of cached ClassInfos and returns the added
	 * ClassInfo.
	 * 
	 * @param info the ClassInfo that shall be added
	 * @return the added ClassInfo
	 */
	public function addClass(info:ClassInfo):ClassInfo {
		classes.put(info.getClass().prototype, info);
		return info;
	}
	
	/**
	 * Returns the PackageInfo representing the package. If the appropriate PackageInfo
	 * has not been cached already and does thus not exist nothing will be returned.
	 *
	 * @param package the package the appropriate PackageInfo shall be found
	 * @return the PackageInfo representing the package
	 */
	public function getPackage(package):PackageInfo {
		return PackageInfo(packages.get(package));
	}
	
	/**
	 * Adds a PackageInfo to the list of cache PackageInfos and returns teh added
	 * PackageInfo.
	 *
	 * @param info the PackageInfo that shall be added
	 * @return the added PackageInfo
	 */
	public function addPackage(info:PackageInfo):PackageInfo {
		packages.put(info.getPackage(), info);
		return info;
	}
	
	/**
	 * Returns the root of the whole hierachy.
	 *
	 * @return the root
	 */
	public function getRoot(Void):RootInfo {
		return root;
	}
}