import org.as2lib.core.BasicClass;
import org.as2lib.aop.advice.DynamicAdviceFactory;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.Call;
import org.as2lib.aop.Advice;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.advice.AdviceFactory;
import org.as2lib.aop.advice.SimpleAdviceFactory;
import org.as2lib.aop.advice.DynamicBeforeAdvice;
import org.as2lib.aop.advice.DynamicAroundAdvice;
import org.as2lib.aop.advice.DynamicAfterAdvice;
import org.as2lib.aop.advice.DynamicAfterReturningAdvice;
import org.as2lib.aop.advice.DynamicAfterThrowingAdvice;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.SimpleDynamicAdviceFactory extends BasicClass implements DynamicAdviceFactory {
	private var registry:Array;
	
	public function SimpleDynamicAdviceFactory(Void) {
		registry = new Array();
		registry[AbstractAdvice.TYPE_BEFORE] = new SimpleAdviceFactory(DynamicBeforeAdvice);
		registry[AbstractAdvice.TYPE_AROUND] = new SimpleAdviceFactory(DynamicAroundAdvice);
		registry[AbstractAdvice.TYPE_AFTER] = new SimpleAdviceFactory(DynamicAfterAdvice);
		registry[AbstractAdvice.TYPE_AFTER_RETURNING] = new SimpleAdviceFactory(DynamicAfterReturningAdvice);
		registry[AbstractAdvice.TYPE_AFTER_THROWING] = new SimpleAdviceFactory(DynamicAfterThrowingAdvice);
	}
	
	public function getAdvice():Advice {
		var o:Overload = new Overload(this);
		o.addHandler([String, Call], getAdviceByStringAndCall);
		o.addHandler([Pointcut, Call], getAdviceByPointcutAndCall);
		o.addHandler([Number, String, Call], getAdviceByTypeAndStringAndCall);
		o.addHandler([Number, Pointcut, Call], getAdviceByTypeAndPointcutAndCall);
		return o.forward(arguments);
	}
	
	public function getAdviceByStringAndCall(pointcut:String, callback:Call):Advice {
		return getAdviceByTypeAndStringAndCall(registry[AbstractAdvice.TYPE_BEFORE], pointcut, callback);
	}
	
	public function getAdviceByPointcutAndCall(pointcut:Pointcut, callback:Call):Advice {
		return getAdviceByTypeAndPointcutAndCall(registry[AbstractAdvice.TYPE_BEFORE], pointcut, callback);
	}
	
	public function getAdviceByTypeAndStringAndCall(type:Number, pointcut:String, callback:Call):Advice {
		return AdviceFactory(registry[type]).getAdvice(pointcut, callback);
	}
	
	public function getAdviceByTypeAndPointcutAndCall(type:Number, pointcut:Pointcut, callback:Call):Advice {
		return AdviceFactory(registry[type]).getAdvice(pointcut, callback);
	}
}