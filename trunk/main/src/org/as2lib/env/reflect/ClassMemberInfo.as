import org.as2lib.core.BasicInterface;
import org.as2lib.env.reflect.ClassInfo;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.ClassMemberInfo extends BasicInterface {
	/**
	 * Returns the name of the class member.
	 *
	 * @return the class member's name
	 */
	public function getName(Void):String;
	
	/**
	 * Returns the declaring class of the class member.
	 *
	 * @return the class member's declaring class
	 */
	public function getDeclaringClass(Void):ClassInfo;
	
	/**
	 * Returns whether the class member is static or not.
	 *
	 * @return true when the property is static else false
	 */
	public function isStatic(Void):Boolean;
}