import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.env.EnvConfig;

/**
 * ClassInfo represents a real class in the Flash environment. This class is used
 * to store information about the class it represents.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 * @see org.as2lib.env.reflect.CacheInfo
 */
class org.as2lib.env.reflect.ClassInfo extends BasicClass implements CacheInfo {
	/** The name of the class. */
	private var name:String;
	
	/** The full name of the class. This means the name with the whole path. */
	private var fullName:String;
	
	/** The class this ClassInfo represents. */
	private var clazz:Function;
	
	/** The super class's ClassInfo of the class. */
	private var superClass:ClassInfo;
	
	/** The package that contains the class. */
	private var parent:PackageInfo;
	
	/** The methods the class has. */
	private var methods:Map;
	
	/** The properties of the class. */
	private var properties:Map;
	
	/**
	 * Constructs a new ClassInfo.
	 * 
	 * @param name the name of the class
	 * @param class the class the newly created ClassInfo represents
	 * @param parent the parent of the class
	 */
	public function ClassInfo(name:String, 
							  clazz:Function, 
							  parent:PackageInfo) {
		this.name = name;
		this.clazz = clazz;
		this.parent = parent;
	}
	
	/**
	 * Returns the name of the class.
	 *
	 * @return the name of the class
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the full name of the class. Lazy loading is used here. That means
	 * that the full name will not be resolved until this method is called. Once
	 * the full name has been resolved it will be stored.
	 *
	 * @return the full name of the class
	 */
	public function getFullName(Void):String {
		if (ObjectUtil.isEmpty(fullName)) {
			if (getParent().isRoot()) {
				return (fullName = getName());
			}
			fullName = getParent().getFullName() + "." + getName();
		}
		return fullName;
	}
	
	/**
	 * Returns the class this ClassInfo represents.
	 *
	 * @return the class represented by this ClassInfo
	 */
	public function getClass(Void):Function {
		return clazz;
	}
	
	/**
	 * Returns the super class's ClassInfo of the class this ClassInfo represents.
	 * The lazy loading strategy is used here to prevent doing the work if it is
	 * not needed at all.
	 * 
	 * @return the super class's ClassInfo
	 */
	public function getSuperClass(Void):ClassInfo {
		if (ObjectUtil.isEmpty(superClass)) {
			superClass = ReflectUtil.getClassInfo(clazz.prototype);
		}
		return superClass;
	}
	
	/**
	 * Creates a new instance of the class.
	 *
	 * @return a new instance of the class
	 */
	public function newInstance(Void) {
		return (new clazz());
	}
	
	/**
	 * Returns the parent of the class. The parent is the package represented
	 * by a PackageInfo the class resides in.
	 *
	 * @return the parent of the class
	 */
	public function getParent(Void):PackageInfo {
		return parent;
	}
	
	/**
	 * Returns a HashMap containing the operations represented by MethodInfos
	 * the class has. Lazy loading is used.
	 *
	 * @return a HashMap containing MethodInfos representing the operations
	 */
	public function getMethods(Void):Map {
		if (ObjectUtil.isEmpty(methods)) {
			methods = ReflectUtil.getMethods(this);
		}
		return methods;
	}
	
	/**
	 * Returns a HashMap containing the properties represented by PropertyInfos
	 * the class has. Lazy loading is used.
	 *
	 * @return a HashMap containing PropertyInfos representing the properties
	 */
	public function getProperties(Void):Map {
		if (ObjectUtil.isEmpty(properties)) {
			properties = ReflectUtil.getProperties(this);
		}
		return properties;
	}
	
	/**
	 * Returns null becuase the class cannot contain any children.
	 *
	 * @return null
	 */
	public function getChildren(Void):Map {
		return null;
	}
}