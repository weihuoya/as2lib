import org.as2lib.aop.Aspect;
import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.advice.AfterAdvice;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AbstractAfterAdvice extends AbstractAdvice {
	private function AbstractAfterAdvice(aspect:Aspect) {
		super(aspect);
	}
	
	public function getProxy(joinPoint:JoinPoint):Function {
		var result:Function = function() {
			var advice:AfterAdvice = AfterAdvice(arguments.callee.advice);
			var tempJoinPoint:JoinPoint = JoinPoint(arguments.callee.joinPoint);
			var joinPoint:JoinPoint = tempJoinPoint.getClass().newInstance([tempJoinPoint.getInfo(), this]);
			var returnValue;
			try {
				returnValue = joinPoint.proceed(arguments);
			} catch (throwable:org.as2lib.env.except.Throwable) {
				advice.execute(joinPoint);
				throw throwable;
			}
			advice.execute(joinPoint, returnValue);
			return returnValue;
		};
		result.advice = this;
		result.joinPoint = joinPoint;
		return result;
	}
}