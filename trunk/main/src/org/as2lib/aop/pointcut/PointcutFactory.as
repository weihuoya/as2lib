import org.as2lib.core.BasicInterface;
import org.as2lib.aop.Pointcut;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.pointcut.PointcutFactory extends BasicInterface {
	public function getPointcut(pattern:String):Pointcut;
}