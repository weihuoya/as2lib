import org.as2lib.core.BasicClass;
import org.as2lib.aop.matcher.Matcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.AbstractJoinPoint extends BasicClass {
	public static var TYPE_METHOD:Number = 0;
	public static var TYPE_PROPERTY:Number = 1;
	public static var TYPE_SET_PROPERTY:Number = 2;
	public static var TYPE_GET_PROPERTY:Number = 3;
	
	private function AbstractJoinPoint(Void) {
	}
	
	public function matches(pattern:String):Boolean {
		return Matcher.match((this["getInfo"]().getDeclaringType().getFullName() + "." + this["getInfo"]().getName()), pattern);
	}
}