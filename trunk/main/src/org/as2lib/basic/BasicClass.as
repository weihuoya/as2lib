import org.as2lib.basic.BasicInterface;
import org.as2lib.basic.Overloading;
import org.as2lib.basic.OverloadHandler;
import org.as2lib.reflect.ClassInfo;
import org.as2lib.reflect.SimpleClassInfo;
import org.as2lib.util.OverloadingUtil;

/**
 * The basic class that implements the basic functionalities.
 */
class org.as2lib.basic.BasicClass implements BasicInterface, Overloading {
	/**
	 * @see org.as2lib.basic.BasicInterface
	 */
	public function getClass(Void):ClassInfo {
		// just to get no errors
		return new SimpleClassInfo();
	}
	
	/**
	 * @see org.as2lib.basic.Overloading
	 */
	public function overload(someArguments:Array, someOverloadHandlers:Array):Void {
		OverloadingUtil.overload(this, someArguments, someOverloadHandlers);
	}
	
	/**
	 * @see org.as2lib.basic.Overloading
	 */
	public function newOverloadHandler(someArguments:Array, aFunction:String):OverloadHandler {
		return OverloadingUtil.newOverloadHandler(someArguments, aFunction);
	}
}