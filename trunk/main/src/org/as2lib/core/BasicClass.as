import org.as2lib.core.BasicInterface;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;

/**
 * BasicClass is the basic class with default implementations of the functionality
 * offered by the BasicInterface.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.core.BasicClass implements BasicInterface {
	/**
	 * Uses the ReflectUtil#getClassInfo() operation to fulfill the task.
	 *
	 * @see org.as2lib.core.BasicInterface#getClass()
	 * @see org.as2lib.env.util.ReflectUtil;
	 */
	public function getClass(Void):ClassInfo {
		return ReflectUtil.getClassInfo(this);
	}
	
	/**
	 * Returns a String representation of the instance. The String representation
	 * is obtained via the Stringifier obtained from the ObjectUtil#getStringifier()
	 * operation.
	 *
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return ObjectUtil.getStringifier().execute(this);
	}
}