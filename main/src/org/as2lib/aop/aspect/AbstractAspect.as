import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.Overload;
import org.as2lib.aop.Advice;
import org.as2lib.aop.Pointcut;
import org.as2lib.util.Call;
import org.as2lib.aop.advice.AdviceConfig;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.aspect.AbstractAspect extends BasicClass {
	private var adviceArray:Array;
	
	private function AbstractAspect(Void) {
		adviceArray = new Array();
	}
	
	public function getAdvices(Void):Array {
		return adviceArray;
	}
	
	private function addAdvice() {
		var o:Overload = new Overload(this);
		o.addHandler([Advice], addAdviceByAdvice);
		o.addHandler([Number, String, Function], addAdviceByTypeAndStringAndMethod);
		o.addHandler([Number, Pointcut, Function], addAdviceByTypeAndPointcutAndMethod);
		return o.forward(arguments);
	}
	
	private function addAdviceByAdvice(advice:Advice):Void {
		adviceArray.push(advice);
	}
	
	private function addAdviceByTypeAndStringAndMethod(type:Number, pointcut:String, method:Function):Advice {
		var callback:Call = new Call(this, method);
		var result:Advice = AdviceConfig.getDynamicAdviceFactory().getAdvice(type, pointcut, callback);
		addAdviceByAdvice(result);
		return result;
	}
	
	private function addAdviceByTypeAndPointcutAndMethod(type:Number, pointcut:Pointcut, method:Function):Advice {
		var callback:Call = new Call(this, method);
		var result:Advice = AdviceConfig.getDynamicAdviceFactory().getAdvice(type, pointcut, callback);
		addAdviceByAdvice(result);
		return result;
	}
}