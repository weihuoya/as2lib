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
		var owner:AbstractBeforeAdvice = this;
		return (function() {
			joinPoint = joinPoint.getClass().newInstance([joinPoint.getInfo(), this]);
			return owner.executeJoinPoint(joinPoint, arguments);
		});
	}
	
	private function executeJoinPoint(joinPoint:JoinPoint, args:Array) {
		this["execute"](joinPoint, args);
		return joinPoint.proceed(args);
	}
}