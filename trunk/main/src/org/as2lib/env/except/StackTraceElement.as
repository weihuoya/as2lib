import org.as2lib.core.BasicInterface;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.except.StackTraceElement extends BasicInterface {
	public function getThrower(Void):ClassInfo;
	
	public function getMethod(Void):MethodInfo;
}