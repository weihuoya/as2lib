import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.Advice;
import org.as2lib.aop.Aspect;
import org.as2lib.aop.JoinPoint;
import org.as2lib.aop.pointcut.PointcutConfig;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AbstractAdvice extends BasicClass {
	public static var TYPE_BEFORE:Number = 0;
	public static var TYPE_AROUND:Number = 1;
	public static var TYPE_AFTER:Number = 2;
	public static var TYPE_AFTER_RETURNING:Number = 3;
	public static var TYPE_AFTER_THROWING:Number = 4;
	
	private var pointcut:Pointcut;
	private var aspect:Aspect;
	
	private function AbstractAdvice(aspect:Aspect) {
		setAspect(aspect);
	}
	
	private function setAspect(newAspect:Aspect):Void {
		aspect = newAspect;
	}
	
	private function getAspect(Void):Aspect {
		return aspect;
	}
	
	private function setPointcut(pointcut) {
		var overload:Overload = new Overload(this);
		overload.addHandler([Pointcut], setPointcutByPointcut);
		overload.addHandler([String], setPointcutByString);
		overload.forward(arguments);
	}
	
	private function setPointcutByPointcut(newPointcut:Pointcut):Void {
		pointcut = newPointcut;
	}
	
	private function setPointcutByString(pointcutString:String):Pointcut {
		var result:Pointcut = PointcutConfig.getPointcutFactory().getPointcut(pointcutString);
		setPointcutByPointcut(result);
		return result;
	}
	
	private function getPointcut(Void):Pointcut {
		return pointcut;
	}
	
	public function captures(joinPoint:JoinPoint):Boolean {
		return pointcut.captures(joinPoint);
	}
}