import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.joinpoint.AbstractJoinPoint extends BasicClass {
	public static var TYPE_METHOD:Number = 0;
	public static var TYPE_PROPERTY:Number = 1;
	public static var TYPE_PROPERTY_SET:Number = 2;
	public static var TYPE_PROPERTY_GET:Number = 3;
	
	private function AbstractJoinPoint(Void) {
	}
}