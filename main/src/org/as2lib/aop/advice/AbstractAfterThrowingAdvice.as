import org.as2lib.aop.Aspect;
import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.advice.AfterThrowingAdvice;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AbstractAfterThrowingAdvice extends AbstractAdvice {
	private function AbstractAfterThrowingAdvice(aspect:Aspect) {
		super(aspect);
	}
	
	public function getProxy(joinPoint:JoinPoint):Function {
		var result:Function = function() {
			var advice:AfterThrowingAdvice = AfterThrowingAdvice(arguments.callee.advice);
			var tempJoinPoint:JoinPoint = JoinPoint(arguments.callee.joinPoint);
			var joinPoint:JoinPoint = tempJoinPoint.getClass().newInstance([tempJoinPoint.getInfo(), this]);
			var returnValue;
			try {
				returnValue = joinPoint.proceed(arguments);
			} catch (throwable:org.as2lib.env.except.Throwable) {
				advice.execute(joinPoint, throwable);
				throw throwable;
			}
			return returnValue;
		};
		result.advice = this;
		result.joinPoint = joinPoint;
		return result;
	}
}