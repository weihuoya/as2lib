import org.as2lib.core.BasicInterface;
import org.as2lib.util.ObjectUtil;
import org.as2lib.aop.Advice;
import org.as2lib.aop.advice.BeforeAdvice;
import org.as2lib.aop.advice.AfterAdvice;
import org.as2lib.aop.advice.AfterReturningAdvice;
import org.as2lib.aop.advice.AfterThrowingAdvice;
import org.as2lib.aop.advice.AroundAdvice;
import org.as2lib.aop.JoinPoint;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.proxy.MethodProxyFactory extends BasicInterface {
	public function getMethodProxy(joinPoint:JoinPoint, advice:Advice):Function;
	public function getBeforeMethodProxy(joinPoint:JoinPoint, advice:BeforeAdvice):Function;
	public function getAfterMethodProxy(joinPoint:JoinPoint, advice:AfterAdvice):Function;
	public function getAfterReturningMethodProxy(joinPoint:JoinPoint, advice:AfterReturningAdvice):Function;
	public function getAfterThrowingMethodProxy(joinPoint:JoinPoint, advice:AfterThrowingAdvice):Function;
	public function getAroundMethodProxy(joinPoint:JoinPoint, advice:AroundAdvice):Function;
}