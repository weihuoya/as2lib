import org.as2lib.core.BasicClass;
import org.as2lib.env.reflect.CacheInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorythm.AbstractContentAlgorythm extends BasicClass {
	/**
	 * Private constructor.
	 */
	private function AbstractContentAlgorythm(Void) {
	}
	
	/**
	 * Searches for the passed object. It uses the validate operation to check
	 * if the right object has been found. If it has been found it uses the store
	 * operation to store the result.
	 *
	 * @param target the object to be searched for
	 */
	public function search(target):Void {
		var i:String;
		for (i in target) {
			if (validate(target, i)) {
				store(i, target);
			}
		}
	}
	
	/**
	 *
	 */
	private function validate(target, name:String):Boolean {
		return true;
	}
	
	/**
	 *
	 */
	private function store(name:String, target):Void {
	}
}