import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.aop.aspect.TypeFactory;
import org.as2lib.aop.aspect.SimpleTypeFactory;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.aspect.AspectConfig extends BasicClass {
	private static var typeFactory:TypeFactory;
	
	private function AspectConfig(Void) {
	}
	
	public static function setTypeFactory(factory:TypeFactory):Void {
		typeFactory = factory;
	}
	
	public static function getTypeFactory(Void):TypeFactory {
		if (ObjectUtil.isEmpty(typeFactory)) {
			typeFactory = new SimpleTypeFactory();
		}
		return typeFactory;
	}
}