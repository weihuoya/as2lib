import org.as2lib.aop.advice.AbstractAfterThrowingAdvice;
import org.as2lib.aop.advice.AfterThrowingAdvice;
import org.as2lib.util.Call;
import org.as2lib.aop.JoinPoint;
import org.as2lib.env.except.Throwable;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.DynamicAfterThrowingAdvice extends AbstractAfterThrowingAdvice implements AfterThrowingAdvice {
	private var callback:Call;
	
	public function DynamicAfterThrowingAdvice(pointcut, callback:Call) {
		setPointcut(pointcut);
		this.callback = callback;
	}
	
	public function execute(joinPoint:JoinPoint, throwable:Throwable):Void {
		callback.execute([joinPoint, throwable]);
	}
}