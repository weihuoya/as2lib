import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.util.ReflectUtil;

/**
 * ObjectStringifier is the most basic form of Stringifiers. It stringifies all
 * kinds of objects.
 *
 * @author Simon Wacker
 */
class org.as2lib.core.string.ObjectStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.core.string.Stringifier
	 */
	public function execute(target):String {
		return ReflectUtil.getClassInfo(target).getName();
	}
}