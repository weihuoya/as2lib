import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.reflect.ReferenceNotFoundException;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.StringUtil;

/**
 * StackTraceElementStringifier is used to stringify StackTraceElements.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 * @see org.as2lib.core.string.Stringifier
 */
class org.as2lib.env.except.StackTraceElementStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.core.string.Stringifier#execute()
	 */
	public function execute(target):String {
		var element:StackTraceElement = StackTraceElement(target);
		var thrower = element.getThrower();
		var method = element.getMethod();
		var methodName:String;
		
		try {
			var throwerName:String = ReflectUtil.getClassInfo(thrower).getFullName();
		} catch(e) {
			var throwerName:String = "[not evaluateable::"+thrower+"]";
		}
		
		var clazz = (ObjectUtil.isTypeOf(thrower, "function")) ? thrower : thrower.__proto__; 

		ObjectUtil.setAccessPermissions(thrower, ObjectUtil.ACCESS_ALL_ALLOWED);
		methodName = ObjectUtil.getChildName(thrower, method);

		if(methodName == null) {
			ObjectUtil.setAccessPermissions(clazz, ObjectUtil.ACCESS_ALL_ALLOWED);
			methodName = ObjectUtil.getChildName(clazz, method);

			if(methodName == null) {
				// TODO: Search for method in all objects. Trace it like [defined in::whatever]
				methodName = ".[not evaluateable::"+method+"]";
			} else {
				methodName = "."+methodName;
			}
		} else if(methodName == "__constructor__") {
			methodName = "";
			throwerName = "new "+throwerName;
		} else {
			methodName = "."+methodName;
			throwerName = "[static] "+throwerName;
		}
		
		
		if(StringUtil.startsWith(methodName, ".__set__")) {
			if(StringUtil.startsWith(throwerName, "[static]")) {
				return ("set static variable: "+throwerName+"."+methodName.substr(8)+" to "+element.getArguments());
			} else {
				return ("set instance variable: "+throwerName+"."+methodName.substr(8)+" to "+element.getArguments());
			}
		} else if (StringUtil.startsWith(methodName, ".__get__")) {
			if(StringUtil.startsWith(throwerName, "[static]")) {
				return ("get static variable: "+throwerName+"."+methodName.substr(8));
			} else {
				return ("get instance variable: "+throwerName+"."+methodName.substr(8));
			}
		} else {
			return (throwerName + methodName + "("+element.getArguments()+")");
		}
	}
}