import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.aop.pointcut.PointcutFactory;
import org.as2lib.aop.pointcut.SimplePointcutFactory;

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
		if (ObjectUtil.isEmpty(pointcutFactory)) {
			pointcutFactory = new SimplePointcutFactory();
		}
		return pointcutFactory;
	}
}