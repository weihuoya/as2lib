import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.ClassMemberInfo;

/**
 * MethodInfo represents an operation.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.reflect.MethodInfo extends BasicClass implements ClassMemberInfo {
	/** The name of the operation. */
	private var name:String;
	
	/** The actual operation. */
	private var method:Function;
	
	/** The class that declares the operation. */
	private var declaringClass:ClassInfo;
	
	/** A flag representing whether the operaion is static of not. */
	private var staticFlag:Boolean;
	
	/**
	 * Constructs a new MethodInfo.
	 *
	 * @param name the name of the operation
	 * @param method the actual operation
	 * @param declaringClass the declaring class of the operation
	 * @param static a flag representing whether the operation is static
	 */
	public function MethodInfo(name:String,
							   method:Function,
							   declaringClass:ClassInfo,
							   staticFlag:Boolean) {
		this.name = name;
		this.method = method;
		this.declaringClass = declaringClass;
		this.staticFlag = staticFlag;
	}
	
	/**
	 * @see org.as2lib.env.reflect.ClassMemberInfo#getName()
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the actual operation this MethodInfo represents.
	 *
	 * @return the actual operation
	 */
	public function getMethod(Void):Function {
		return method;
	}
	
	/**
	 * @see org.as2lib.env.reflect.ClassMemberInfo#getDeclaringClass()
	 */
	public function getDeclaringClass(Void):ClassInfo {
		return declaringClass;
	}
	
	/**
	 * @see org.as2lib.env.reflect.ClassMemberInfo#isStatic()
	 */
	public function isStatic(Void):Boolean {
		return staticFlag;
	}
}