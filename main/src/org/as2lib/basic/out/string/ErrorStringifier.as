import org.as2lib.basic.BasicClass;
import org.as2lib.basic.string.Stringifier;
import org.as2lib.util.ReflectUtil;

class org.as2lib.basic.out.string.ErrorStringifier extends BasicClass implements Stringifier {
	public function execute(target:Object):String {
		return ReflectUtil.getClassInfo(target).getName();
	}
}