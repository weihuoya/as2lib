import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.util.ObjectUtil;

/**
 * PropertyInfo represents a property.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.reflect.PropertyInfo extends BasicClass {
	/** The name of the property. */
	private var name:String;
	
	/** The setter operation of the property. */
	private var setter:Function;
	
	/** The getter operation of the property. */
	private var getter:Function;
	
	/** The class that declares the property. */
	private var declaringClass:ClassInfo;
	
	/** A flag representing whether the operation is static. */
	private var staticFlag:Boolean;
	
	/**
	 * Constructs a new PropertyInfo.
	 *
	 * @param name the name of the property
	 * @param setter the setter operation of the property
	 * @param getter the getter operation of the property
	 * @param declaringClass the class declaring the property
	 * @param static a flag saying whether the property is static
	 */
	public function PropertyInfo(name:String,
								 setter:Function,
								 getter:Function,
								 declaringClass:ClassInfo,
								 staticFlag:Boolean) {
		this.name = name;
		this.setter = setter;
		this.getter = getter;
		this.declaringClass = declaringClass;
		this.staticFlag = staticFlag;
	}
	
	/**
	 * Returns the name of the property.
	 *
	 * @return the propertie's name
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the setter operation of the property.
	 * 
	 * @return the propertie's setter
	 */
	public function getSetter(Void):Function {
		return setter;
	}
	
	/**
	 * Returns the getter operation of the property.
	 * 
	 * @return the propertie's getter
	 */
	public function getGetter(Void):Function {
		return getter;
	}
	
	/**
	 * Returns the declaring class of the property.
	 *
	 * @return the propertie's declaring class
	 */
	public function getDeclaringClass(Void):ClassInfo {
		return declaringClass;
	}
	
	/**
	 * Returns whether the property is writeable.
	 *
	 * @return true when the property is writeable else false
	 */
	public function isWriteable(Void):Boolean {
		return ObjectUtil.isAvailable(setter);
	}
	
	/**
	 * Returns whether the property is readable.
	 *
	 * @return true when the property is readable else false
	 */
	public function isReadable(Void):Boolean {
		return ObjectUtil.isAvailable(getter);
	}
	
	/**
	 * Returns whether the property is static or not.
	 *
	 * @return true when the property is static else false
	 */
	public function isStatic(Void):Boolean {
		return staticFlag;
	}
}