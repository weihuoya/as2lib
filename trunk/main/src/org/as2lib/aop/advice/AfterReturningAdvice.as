import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.Advice;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.advice.AfterReturningAdvice extends Advice {
	public function execute(joinPoint:JoinPoint, returnValue):Void;
}