import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.pointcut.AbstractPointcut;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.MethodJoinPoint;
import org.as2lib.aop.matcher.Matcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.MethodPointcut extends AbstractPointcut implements Pointcut {
	public function MethodPointcut(description:String) {
		setJoinPointDescription(description);
	}
	
	public function captures(joinPoint:JoinPoint):Boolean {
		if (ObjectUtil.isInstanceOf(joinPoint, MethodJoinPoint)) {
			if (Matcher.matches(joinPoint, getJoinPointDescription())) {
				return true;
			}
		}
		return false;
	}
}