import org.as2lib.core.BasicClass;
import org.as2lib.aop.pointcut.PointcutFactory;
import org.as2lib.aop.pointcut.DynamicPointcutFactory;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.PointcutConfig extends BasicClass {
	private static var pointcutFactory:PointcutFactory;
	
	private function PointcutFactory(Void) {
	}
	
	public static function setPointcutFactory(factory:PointcutFactory):Void {
		pointcutFactory = factory;
	}
	
	public static function getPointcutFactory(Void):PointcutFactory {
		if (!pointcutFactory) pointcutFactory = new DynamicPointcutFactory();
		return pointcutFactory;
	}
}