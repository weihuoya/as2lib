import org.as2lib.aop.advice.AdviceFactory;
import org.as2lib.util.Call;
import org.as2lib.aop.Advice;
import org.as2lib.aop.Pointcut;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.advice.DynamicAdviceFactory extends AdviceFactory {
	public function getAdvice():Advice;
	public function getAdviceByTypeAndStringAndCall(type:Number, pointcut:String, callback:Call):Advice;
	public function getAdviceByTypeAndPointcutAndCall(type:Number, pointcut:Pointcut, callback:Call):Advice;
}