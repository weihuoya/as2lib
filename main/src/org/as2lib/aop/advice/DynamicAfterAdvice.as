import org.as2lib.aop.advice.AbstractAfterAdvice;
import org.as2lib.aop.advice.AfterAdvice;
import org.as2lib.util.Call;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.DynamicAfterAdvice extends AbstractAfterAdvice implements AfterAdvice {
	private var callback:Call;
	
	public function DynamicAfterAdvice(pointcut, callback:Call) {
		setPointcut(pointcut);
		this.callback = callback;
	}
	
	public function execute(joinPoint:JoinPoint):Void {
		callback.execute([joinPoint]);
	}
}