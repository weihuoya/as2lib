import org.as2lib.aop.Aspect;
import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.advice.AroundAdvice;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AbstractAroundAdvice extends AbstractAdvice {
	private function AbstractAroundAdvice(aspect:Aspect) {
		super(aspect);
	}
	
	public function getProxy(joinPoint:JoinPoint):Function {
		var owner:AbstractAroundAdvice = this;
		return (function() {
			joinPoint = joinPoint.getClass().newInstance([joinPoint.getInfo(), this]);
			return owner.executeJoinPoint(joinPoint, arguments);
		});
	}
	
	private function executeJoinPoint(joinPoint:JoinPoint, args:Array) {
		return this["execute"](joinPoint, args);
	}
}