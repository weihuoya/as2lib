import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.pointcut.AbstractPointcut;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.PropertyJoinPoint;
import org.as2lib.aop.matcher.Matcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.PropertyPointcut extends AbstractPointcut implements Pointcut {
	public function PropertyPointcut(description:String) {
		setJoinPointDescription(description);
	}
	
	public function captures(joinPoint:JoinPoint):Boolean {
		if (ObjectUtil.isInstanceOf(joinPoint, PropertyJoinPoint)) {
			if (Matcher.matches(joinPoint, getJoinPointDescription())) {
				return true;
			}
		}
		return false;
	}
}