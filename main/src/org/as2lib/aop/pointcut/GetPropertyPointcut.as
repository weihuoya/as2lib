import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.GetPropertyJoinPoint;
import org.as2lib.aop.pointcut.PropertyPointcut;
import org.as2lib.aop.matcher.Matcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.GetPropertyPointcut extends PropertyPointcut {
	public function GetPropertyPointcut(description:String) {
		setJoinPointDescription(description);
	}
	
	public function captures(joinPoint:JoinPoint):Boolean {
		if (ObjectUtil.isInstanceOf(joinPoint, GetPropertyJoinPoint)) {
			if (Matcher.matches(joinPoint, getJoinPointDescription())) {
				return true;
			}
		}
		return false;
	}
}