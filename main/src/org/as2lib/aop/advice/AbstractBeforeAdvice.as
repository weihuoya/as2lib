import org.as2lib.aop.Aspect;
import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.advice.BeforeAdvice;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AbstractBeforeAdvice extends AbstractAdvice {
	private function AbstractBeforeAdvice(aspect:Aspect) {
		super(aspect);
	}
	
	public function getProxy(joinPoint:JoinPoint):Function {
		var result:Function = function() {
			var advice:BeforeAdvice = BeforeAdvice(arguments.callee.advice);
			var tempJoinPoint:JoinPoint = JoinPoint(arguments.callee.joinPoint);
			var joinPoint:JoinPoint = tempJoinPoint.getClass().newInstance([tempJoinPoint.getInfo(), this]);
			advice.execute(joinPoint, arguments);
			return joinPoint.proceed(arguments);
		};
		result.advice = this;
		result.joinPoint = joinPoint;
		return result;
	}
}