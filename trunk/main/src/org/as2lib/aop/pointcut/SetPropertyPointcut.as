import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.SetPropertyJoinPoint;
import org.as2lib.aop.pointcut.PropertyPointcut;
import org.as2lib.aop.matcher.Matcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.SetPropertyPointcut extends PropertyPointcut {
	public function SetPropertyPointcut(description:String) {
		setJoinPointDescription(description);
	}
	
	public function captures(joinPoint:JoinPoint):Boolean {
		if (ObjectUtil.isInstanceOf(joinPoint, SetPropertyJoinPoint)) {
			if (Matcher.matches(joinPoint, getJoinPointDescription())) {
				return true;
			}
		}
		return false;
	}
}