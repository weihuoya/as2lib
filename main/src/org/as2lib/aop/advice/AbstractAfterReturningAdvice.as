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
		var owner:AbstractAfterReturningAdvice = this;
		return (function() {
			joinPoint = joinPoint.getClass().newInstance([joinPoint.getInfo(), this]);
			return owner.executeJoinPoint(joinPoint, arguments);
		});
	}
	
	private function executeJoinPoint(joinPoint:JoinPoint, args:Array) {
		var result = joinPoint.proceed(args);
		this["execute"](joinPoint, result);
		return result;
	}
}