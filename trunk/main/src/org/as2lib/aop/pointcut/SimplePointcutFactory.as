import org.as2lib.core.BasicClass;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.pointcut.OrCompositePointcut;
import org.as2lib.aop.pointcut.AndCompositePointcut;
import org.as2lib.aop.pointcut.MethodPointcut;
import org.as2lib.aop.pointcut.GetPropertyPointcut;
import org.as2lib.aop.pointcut.SetPropertyPointcut;
import org.as2lib.aop.pointcut.PointcutFactory;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.SimplePointcutFactory extends BasicClass implements PointcutFactory {
	public function SimplePointcutFactory(Void) {
	}
	
	public function getPointcut(description:String):Pointcut {
		if (description.indexOf(" || ") != -1) {
			return (new OrCompositePointcut(description));
		}
		if (description.indexOf(" && ") != -1) {
			return (new AndCompositePointcut(description));
		}
		if (description.indexOf("execution") == 0) {
			description = description.substring(10, description.length - 3);
			return (new MethodPointcut(description));
		}
		if (description.indexOf("set") == 0) {
			description = description.substring(4, description.length - 1);
			return (new SetPropertyPointcut(description));
		}
		if (description.indexOf("get") == 0) {
			description = description.substring(4, description.length - 1);
			return (new GetPropertyPointcut(description));
		}
	}
}