import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.holder.HashMap;
import org.as2lib.env.except.ExceptConfig;
import org.as2lib.env.except.StackTraceElement;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.except.SimpleStackTraceElement extends BasicClass implements StackTraceElement {
	private var thrower;
	private var method:Function;
	private var methodInfo:MethodInfo;
	
	public function SimpleStackTraceElement(thrower, method:Function) {
		this.thrower = thrower;
		this.method = method;
	}
	
	public function getThrower(Void):ClassInfo {
		return ReflectUtil.getClassInfo(thrower);
	}
	
	public function getMethod(Void):MethodInfo {
		if (ObjectUtil.isEmpty(methodInfo)) {
			var methods:HashMap = getThrower().getMethods();
			var iterator:Iterator = methods.iterator();
			var next:MethodInfo;
			while (iterator.hasNext()) {
				next = MethodInfo(iterator.next());
				if (next.getMethod() == method) {
					return (methodInfo = next);
				}
			}
		}
		return methodInfo;
	}
	
	public function toString(Void):String {
		return ExceptConfig.getStackTraceElementStringifier().execute(this);
	}
}