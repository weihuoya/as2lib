import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.data.iterator.Iterator;

/**
 * MapStringifier is the default Stringifier used to stringify Maps.
 *
 * @author Simon Wacker
 * @see org.as2lib.data.holder.Map
 */
class org.as2lib.data.holder.string.MapStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.core.string.Stringifier
	 */
	public function execute(target):String {
		var map:Map = Map(target);
		var result:String = "{";
		var valueIterator:Iterator = new ArrayIterator(map.getValues());
		var keyIterator:Iterator = new ArrayIterator(map.getKeys())
		while (keyIterator.hasNext()) {
			result += keyIterator.next().toString() + "=" + valueIterator.next().toString();
			if (keyIterator.hasNext()) {
				result += ", ";
			}
		}
		result += "}";
		return result;
	}
}