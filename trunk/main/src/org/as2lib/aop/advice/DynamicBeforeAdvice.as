import org.as2lib.aop.advice.AbstractBeforeAdvice;
import org.as2lib.aop.advice.BeforeAdvice;
import org.as2lib.util.Call;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.DynamicBeforeAdvice extends AbstractBeforeAdvice implements BeforeAdvice {
	private var callback:Call;
	
	public function DynamicBeforeAdvice(pointcut, callback:Call) {
		setPointcut(pointcut);
		this.callback = callback;
	}
	
	public function execute(joinPoint:JoinPoint, args:FunctionArguments):Void {
		callback.execute([joinPoint, args]);
	}
}