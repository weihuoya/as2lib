import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.env.except.StackTraceElement;

/**
 * ThrowableStringifier is used to stringify a Throwable.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 * @see org.as2lib.core.string.Stringifier
 */
class org.as2lib.env.except.ThrowableStringifier extends BasicClass implements Stringifier {
	/**
	 * TODO: Good documentation when the working on the stringify process has 
	 * been finished.
	 *
	 * @see org.as2lib.core.string.Stringifier#execute()
	 */
	public function execute(target):String {
		var info:ClassInfo = ReflectUtil.getClassInfo(target);
		return getThrowableString(Throwable(target));
	}
	
	private function getThrowableString(throwable:Throwable):String {
		var info:ClassInfo = ReflectUtil.getClassInfo(throwable);
		return (info.getFullName() + ": " + throwable.getMessage() + "\n" +
				getStackTraceString(throwable.getStackTrace()));
	}
	
	private function getStackTraceString(stack:Stack):String {
		var result:String = "";
		var iterator:Iterator = stack.iterator();
		var next:StackTraceElement;
		while (iterator.hasNext()) {
			next = StackTraceElement(iterator.next());
			trace (next.getMethod());
			result += ("  at " 
					   + next.getThrower().getFullName() + "."
					   + next.getMethod().getName() + "()");
			if (iterator.hasNext()) {
				result += "\n";
			}
		}
		return result;
	}
}