import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.util.ReflectUtil;
import org.as2lib.out.info.OutErrorInfo;

class org.as2lib.out.string.ErrorStringifier extends BasicClass implements Stringifier {
	public function execute(target:Object):String {
		return "Error: " + ReflectUtil.getClassInfo(Object(OutErrorInfo(target).getThrowable())).getName();
	}
}