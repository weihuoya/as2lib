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
 * @see org.as2lib.core.BasicInterface
 */
class org.as2lib.core.BasicClass implements BasicInterface {
	/**
	 * Uses the ReflectUtil#getClassInfo() operation to fulfill the task.
	 *
	 * @see org.as2lib.core.BasicInterface#getClass()
	 */
	public function getClass(Void):ClassInfo {
		return ReflectUtil.getClassInfo(this);
	}
	
	/**
	 * Returns a String representation of the instance. The String representation
	 * is obtained via the ObjectUtil#stringify() operation. You can set your own
	 * Stringifier to change the stringify process and get a custom String
	 * representation of the instance.
	 *
	 * @return a String representation of the instance
	 */
	public function toString(Void):String {
		return ObjectUtil.getStringifier().execute(this);
	}
}