import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.aop.Advice;
import org.as2lib.aop.advice.BeforeAdvice;
import org.as2lib.aop.advice.AfterAdvice;
import org.as2lib.aop.advice.AfterReturningAdvice;
import org.as2lib.aop.advice.AfterThrowingAdvice;
import org.as2lib.aop.advice.AroundAdvice;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.advice.UnsupportedAdviceException;
import org.as2lib.aop.proxy.MethodProxyFactory;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.proxy.SimpleMethodProxyFactory extends BasicClass implements MethodProxyFactory {
	public function SimpleMethodProxyFactory(Void) {
	}
	
	public function getMethodProxy(joinPoint:JoinPoint, advice:Advice):Function {
		if (ObjectUtil.isInstanceOf(advice, BeforeAdvice)) {
			return getBeforeMethodProxy(joinPoint, BeforeAdvice(advice));
		}
		if (ObjectUtil.isInstanceOf(advice, AfterReturningAdvice)) {
			return getAfterReturningMethodProxy(joinPoint, AfterReturningAdvice(advice));
		}
		if (ObjectUtil.isInstanceOf(advice, AfterThrowingAdvice)) {
			return getAfterThrowingMethodProxy(joinPoint, AfterThrowingAdvice(advice));
		}
		if (ObjectUtil.isInstanceOf(advice, AfterAdvice)) {
			return getAfterMethodProxy(joinPoint, AfterAdvice(advice));
		}
		if (ObjectUtil.isInstanceOf(advice, AroundAdvice)) {
			return getAroundMethodProxy(joinPoint, AroundAdvice(advice));
		}
		throw new UnsupportedAdviceException("The passed Advice [" + advice + "] is not supported by this operation.",
											 eval("th" + "is"),
											 arguments);
	}
	
	public function getBeforeMethodProxy(joinPoint:JoinPoint, advice:BeforeAdvice):Function {
		var result:Function = function() {
			var advice:BeforeAdvice = BeforeAdvice(arguments.callee.advice);
			var tempJoinPoint:JoinPoint = JoinPoint(arguments.callee.joinPoint);
			var joinPoint:JoinPoint = tempJoinPoint.getClass().newInstance([tempJoinPoint.getInfo(), this]);
			advice.execute(joinPoint, arguments);
			return joinPoint.proceed(arguments);
		};
		result.advice = advice;
		result.joinPoint = joinPoint;
		return result;
	}
	
	public function getAfterMethodProxy(joinPoint:JoinPoint, advice:AfterAdvice):Function {
		var result:Function = function() {
			var advice:AfterAdvice = AfterAdvice(arguments.callee.advice);
			var tempJoinPoint:JoinPoint = JoinPoint(arguments.callee.joinPoint);
			var joinPoint:JoinPoint = tempJoinPoint.getClass().newInstance([tempJoinPoint.getInfo(), this]);
			var returnValue;
			try {
				returnValue = joinPoint.proceed(arguments);
			} catch (error:Error) {
				if (ObjectUtil.isInstanceOf(error, Throwable)) {
					advice.execute(joinPoint);
				}
				throw error;
			}
			advice.execute(joinPoint, returnValue);
			return returnValue;
		};
		result.advice = advice;
		result.joinPoint = joinPoint;
		return result;
	}
	
	public function getAfterReturningMethodProxy(joinPoint:JoinPoint, advice:AfterReturningAdvice):Function {
		var result:Function = function() {
			var advice:AfterReturningAdvice = AfterReturningAdvice(arguments.callee.advice);
			var tempJoinPoint:JoinPoint = JoinPoint(arguments.callee.joinPoint);
			var joinPoint:JoinPoint = tempJoinPoint.getClass().newInstance([tempJoinPoint.getInfo(), this]);
			var returnValue = joinPoint.proceed(arguments);
			advice.execute(joinPoint, returnValue);
			return returnValue;
		};
		result.advice = advice;
		result.joinPoint = joinPoint;
		return result;
	}
	
	public function getAfterThrowingMethodProxy(joinPoint:JoinPoint, advice:AfterThrowingAdvice):Function {
		var result:Function = function() {
			var advice:AfterThrowingAdvice = AfterThrowingAdvice(arguments.callee.advice);
			var tempJoinPoint:JoinPoint = JoinPoint(arguments.callee.joinPoint);
			var joinPoint:JoinPoint = tempJoinPoint.getClass().newInstance([tempJoinPoint.getInfo(), this]);
			var returnValue;
			try {
				returnValue = joinPoint.proceed(arguments);
			} catch (error:Error) {
				if (ObjectUtil.isInstanceOf(error, Throwable)) {
					advice.execute(joinPoint, Throwable(error));
				}
				throw error;
			}
			return returnValue;
		};
		result.advice = advice;
		result.joinPoint = joinPoint;
		return result;
	}
	
	public function getAroundMethodProxy(joinPoint:JoinPoint, advice:AroundAdvice):Function {
		var result:Function = function() {
			var advice:AroundAdvice = AroundAdvice(arguments.callee.advice);
			var tempJoinPoint:JoinPoint = JoinPoint(arguments.callee.joinPoint);
			var joinPoint:JoinPoint = tempJoinPoint.getClass().newInstance([tempJoinPoint.getInfo(), this]);
			return advice.execute(joinPoint, arguments);
		};
		result.advice = advice;
		result.joinPoint = joinPoint;
		return result;
	}
}