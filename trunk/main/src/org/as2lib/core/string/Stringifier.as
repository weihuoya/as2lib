import org.as2lib.core.BasicInterface;

/**
 * Stringifiers are used to stringify any kind of object.
 *
 * @author Simon Wacker
 */
interface org.as2lib.core.string.Stringifier extends BasicInterface {
	/**
	 * Returns a String representation of the passed object.
	 *
	 * @param target the target object to be stringified
	 */
	public function execute(target):String;
}