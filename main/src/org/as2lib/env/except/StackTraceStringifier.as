import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.except.Throwable;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.env.except.StackTraceElement;

/**
 * StackTraceStringifier is used to stringify stack traces returned by Throwable#getStackTrace().
 *
 * @author Simon Wacker
 */
class org.as2lib.env.except.StackTraceStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.core.string.Stringifier#execute()
	 */
	public function execute(target):String {
		var stack:Stack = Stack(target);
		var result:String = "";
		var iterator:Iterator = stack.iterator();
		var element:StackTraceElement;
		while (iterator.hasNext()) {
			element = StackTraceElement(iterator.next());
			result += ("  at " 
					   + element.toString());
			if (iterator.hasNext()) {
				result += "\n";
			}
		}
		return result;
	}
}