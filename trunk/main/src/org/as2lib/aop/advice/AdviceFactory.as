import org.as2lib.core.BasicInterface;
import org.as2lib.util.Call;
import org.as2lib.aop.Advice;
import org.as2lib.aop.Pointcut;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.advice.AdviceFactory extends BasicInterface {
	public function getAdvice():Advice;
	public function getAdviceByStringAndCall(pointcut:String, callback:Call):Advice;
	public function getAdviceByPointcutAndCall(pointcut:Pointcut, callback:Call):Advice;
}