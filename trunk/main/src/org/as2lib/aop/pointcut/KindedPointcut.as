import org.as2lib.aop.pointcut.AbstractPointcut;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.KindedPointcut extends AbstractPointcut implements Pointcut {
	private var matchingJoinPoint:Number;
	
	public function KindedPointcut(description:String, matchingJoinPoint:Number) {
		setJoinPointDescription(description);
		this.matchingJoinPoint = matchingJoinPoint;
	}
	
	public function captures(joinPoint:JoinPoint):Boolean {
		return (joinPoint.getType() == matchingJoinPoint
					&& joinPoint.matches(getJoinPointDescription()));
	}
}