import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.util.ReflectUtil;

class org.as2lib.core.string.ObjectStringifier extends BasicClass implements Stringifier {
	public function execute(target:Object):String {
		return ReflectUtil.getClassInfo(target).getName();
	}
}