import org.as2lib.basic.BasicInterface;
import org.as2lib.basic.overload.Overload;
import org.as2lib.basic.overload.OverloadHandler;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.util.OverloadUtil;
import org.as2lib.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;

/**
 * The basic class that implements the basic functionalities.
 */
class org.as2lib.basic.BasicClass implements BasicInterface, Overload {
	/**
	 * @see org.as2lib.basic.BasicInterface
	 */
	public function getClass(Void):ClassInfo {
		return ReflectUtil.getClassInfo(this);
	}
	
	/**
	 * @see org.as2lib.basic.Overload
	 */
	public function overload(someArguments:Array, someOverloadHandlers:Array):Object {
		return OverloadUtil.overload(this, someArguments, someOverloadHandlers);
	}
	
	/**
	 * @see org.as2lib.basic.Overload
	 */
	public function newOverloadHandler(someArguments:Array, aFunction:Function):OverloadHandler {
		return OverloadUtil.newHandler(someArguments, aFunction);
	}
	
	public function toString(Void):String {
		return ObjectUtil.stringify(this);
	}
}