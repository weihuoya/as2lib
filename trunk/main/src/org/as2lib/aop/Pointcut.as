import org.as2lib.core.BasicInterface;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.Pointcut extends BasicInterface {
	public function captures(joinPoint:JoinPoint):Boolean;
}