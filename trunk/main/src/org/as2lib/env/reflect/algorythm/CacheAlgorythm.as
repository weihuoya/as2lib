import org.as2lib.env.reflect.CacheInfo;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.algorythm.CacheAlgorythm {
	/**
	 * Executes the algorythm and returns the searched for CacheInfo.
	 *
	 * @param object the object you search for
	 * @return the searched for CacheInfo
	 */
	public function execute(object):CacheInfo;
}