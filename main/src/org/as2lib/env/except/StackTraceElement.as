import org.as2lib.core.BasicInterface;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;

/**
 * @author Simon Wacker, Martin Heidegger
 */
interface org.as2lib.env.except.StackTraceElement extends BasicInterface {
	public function getThrower(Void);
	
	public function getMethod(Void):Function;
	
	public function getArguments(Void):FunctionArguments;
}