import org.as2lib.core.BasicInterface;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.MethodInfo;

/**
 * StackTraceElement represents an element in the stack trace returned by
 * Throwable#getStackTrace().
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
interface org.as2lib.env.except.StackTraceElement extends BasicInterface {
	public function getThrower(Void);
	
	public function getMethod(Void):Function;
	
	public function getArguments(Void):FunctionArguments;
}