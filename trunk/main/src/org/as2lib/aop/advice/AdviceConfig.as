import org.as2lib.core.BasicClass;
import org.as2lib.aop.advice.AdviceFactory;
import org.as2lib.aop.advice.DynamicAdviceFactory;
import org.as2lib.aop.advice.SimpleDynamicAdviceFactory;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AdviceConfig extends BasicClass {
	private static var dynamicAdviceFactory:DynamicAdviceFactory;
	
	public static function getDynamicAdviceFactory(Void):DynamicAdviceFactory {
		if (!dynamicAdviceFactory) dynamicAdviceFactory = new SimpleDynamicAdviceFactory();
		return dynamicAdviceFactory;
	}
	
	private function AdviceConfig(Void) {
	}
}