import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.data.holder.Map;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.algorythm.ContentAlgorythm {
	/**
	 * Executes the algorythm and returns a HashMap containing the searched for
	 * values.
	 *
	 * @param info a CacheInfo used as the basis of the search
	 * @return a HashMap containing the searched for values
	 */
	public function execute(info:CacheInfo):Map;
}