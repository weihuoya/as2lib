import org.as2lib.aop.advice.AbstractAroundAdvice;
import org.as2lib.aop.advice.AroundAdvice;
import org.as2lib.util.Call;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.DynamicAroundAdvice extends AbstractAroundAdvice implements AroundAdvice {
	private var callback:Call;
	
	public function DynamicAroundAdvice(pointcut, callback:Call) {
		setPointcut(pointcut);
		this.callback = callback;
	}
	
	public function execute(joinPoint:JoinPoint, args:FunctionArguments) {
		callback.execute([joinPoint, args]);
	}
}