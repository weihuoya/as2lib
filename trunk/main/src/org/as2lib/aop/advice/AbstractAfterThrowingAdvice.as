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
		var owner:AbstractAfterThrowingAdvice = this;
		return (function() {
			joinPoint = joinPoint.getClass().newInstance([joinPoint.getInfo(), this]);
			return owner.executeJoinPoint(joinPoint, arguments);
		});
	}
	
	private function executeJoinPoint(joinPoint:JoinPoint, args:Array) {
		var result;
		try {
			result = joinPoint.proceed(args);
		} catch (throwable:org.as2lib.env.except.Throwable) {
			this["execute"](joinPoint, throwable);
			throw throwable;
		}
		return result;
	}
}