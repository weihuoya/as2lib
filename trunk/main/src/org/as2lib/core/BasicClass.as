﻿import org.as2lib.core.BasicInterface;
import org.as2lib.overload.OverloadHandler;
import org.as2lib.overload.SimpleOverloadHandler;
import org.as2lib.reflect.ClassInfo;
import org.as2lib.util.OverloadUtil;
import org.as2lib.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;

/**
 * The basic class that implements the basic functionalities.
 */
class org.as2lib.core.BasicClass implements BasicInterface {
	/**
	 * @see org.as2lib.core.BasicInterface
	 */
	public function getClass(Void):ClassInfo {
		return ReflectUtil.getClassInfo(this);
	}
	
	public function newOverloadHandler(args:Array, func:Function):OverloadHandler {
		return (new SimpleOverloadHandler(args, func));
	}
	
	public function toString(Void):String {
		return ObjectUtil.stringify(this);
	}
}