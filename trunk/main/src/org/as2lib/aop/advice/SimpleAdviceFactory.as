import org.as2lib.core.BasicClass;
import org.as2lib.aop.advice.AdviceFactory;
import org.as2lib.env.overload.Overload;
import org.as2lib.util.Call;
import org.as2lib.aop.Advice;
import org.as2lib.aop.Pointcut;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.SimpleAdviceFactory extends BasicClass implements AdviceFactory {
	private var advice:Function;
	
	public function SimpleAdviceFactory(advice:Function) {
		this.advice = advice;
	}
	
	public function getAdvice():Advice {
		var o:Overload = new Overload(this);
		o.addHandler([String, Call], getAdviceByStringAndCall);
		o.addHandler([Pointcut, Call], getAdviceByPointcutAndCall);
		return o.forward(arguments);
	}
	
	public function getAdviceByStringAndCall(pointcut:String, callback:Call):Advice {
		return Advice(new advice(pointcut, callback));
	}
	
	public function getAdviceByPointcutAndCall(pointcut:Pointcut, callback:Call):Advice {
		return Advice(new advice(pointcut, callback));
	}
}