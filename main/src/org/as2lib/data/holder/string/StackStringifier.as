import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.iterator.Iterator;

/**
 * StackStringifier is the default Stringifier used to stringify Stacks.
 *
 * @author Simon Wacker
 * @see org.as2lib.data.holder.Stack
 */
class org.as2lib.data.holder.string.StackStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.core.string.Stringifier
	 */
	public function execute(target):String {
		var stack:Stack = Stack(target);
		var result:String = "[";
		var iterator:Iterator = stack.iterator();
		while (iterator.hasNext()) {
			result += iterator.next().toString();
			if (iterator.hasNext()) {
				result += ", ";
			}
		}
		result += "]";
		return result;
	}
}