import org.as2lib.env.except.Throwable;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.Advice;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.advice.AfterThrowingAdvice extends Advice {
	public function execute(joinPoint:JoinPoint, throwable:Throwable):Void;
}