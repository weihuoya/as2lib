import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.util.ReflectUtil;

class org.as2lib.core.string.ObjectStringifier extends BasicClass implements Stringifier {
	public function execute(target):String {
		return ReflectUtil.getClassInfo(target).getName();
	}
}