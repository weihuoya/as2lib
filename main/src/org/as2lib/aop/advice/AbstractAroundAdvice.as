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
		var result:Function = function() {
			var advice:AroundAdvice = AroundAdvice(arguments.callee.advice);
			var tempJoinPoint:JoinPoint = JoinPoint(arguments.callee.joinPoint);
			var joinPoint:JoinPoint = tempJoinPoint.getClass().newInstance([tempJoinPoint.getInfo(), this]);
			return advice.execute(joinPoint, arguments);
		};
		result.advice = this;
		result.joinPoint = joinPoint;
		return result;
	}
}