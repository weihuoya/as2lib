import org.as2lib.aop.Aspect;
import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.advice.AfterReturningAdvice;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AbstractAfterReturningAdvice extends AbstractAdvice {
	private function AbstractAfterReturningAdvice(aspect:Aspect) {
		super(aspect);
	}
	
	public function getProxy(joinPoint:JoinPoint):Function {
		var result:Function = function() {
			var advice:AfterReturningAdvice = AfterReturningAdvice(arguments.callee.advice);
			var tempJoinPoint:JoinPoint = JoinPoint(arguments.callee.joinPoint);
			var joinPoint:JoinPoint = tempJoinPoint.getClass().newInstance([tempJoinPoint.getInfo(), this]);
			var returnValue = joinPoint.proceed(arguments);
			advice.execute(joinPoint, returnValue);
			return returnValue;
		};
		result.advice = this;
		result.joinPoint = joinPoint;
		return result;
	}
}