import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.data.holder.Queue;
import org.as2lib.data.iterator.Iterator;

/**
 * @author Simon Wacker
 */
class org.as2lib.data.holder.string.QueueStringifier extends BasicClass implements Stringifier {
	public function execute(target):String {
		var queue:Queue = Queue(target);
		var result:String = "[";
		var iterator:Iterator = queue.iterator();
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