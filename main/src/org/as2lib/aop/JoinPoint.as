import org.as2lib.core.BasicInterface;
import org.as2lib.env.reflect.TypeMemberInfo;

/**
 * @author Simon Wacker
 */
interface org.as2lib.aop.JoinPoint extends BasicInterface {
	public function getInfo(Void):TypeMemberInfo;
	public function proceed(args:Array);
	public function getThis(Void);
	public function clone(Void):JoinPoint;
}