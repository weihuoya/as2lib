import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.joinpoint.AbstractJoinPoint;
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
		if (joinPoint.getType() == AbstractJoinPoint.TYPE_PROPERTY_GET) {
			if (Matcher.matches(joinPoint, getJoinPointDescription())) {
				return true;
			}
		}
		return false;
	}
}