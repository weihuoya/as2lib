import org.as2lib.aop.advice.AbstractAfterReturningAdvice;
import org.as2lib.aop.advice.AfterReturningAdvice;
import org.as2lib.util.Call;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.DynamicAfterReturningAdvice extends AbstractAfterReturningAdvice implements AfterReturningAdvice {
	private var callback:Call;
	
	public function DynamicAfterReturningAdvice(pointcut, callback:Call) {
		setPointcut(pointcut);
		this.callback = callback;
	}
	
	public function execute(joinPoint:JoinPoint, returnValue):Void {
		callback.execute([joinPoint, returnValue]);
	}
}