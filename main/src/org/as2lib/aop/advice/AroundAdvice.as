import org.as2lib.core.BasicInterface;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.Advice;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.advice.AroundAdvice extends Advice {
	public function execute(joinPoint:JoinPoint, args:FunctionArguments);
}