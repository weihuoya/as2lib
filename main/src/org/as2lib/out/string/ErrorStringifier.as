import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.util.ReflectUtil;
import org.as2lib.out.info.OutErrorInfo;
import org.as2lib.util.ExceptUtil;

class org.as2lib.out.string.ErrorStringifier extends BasicClass implements Stringifier {
	public function execute(target):String {
		return "** "+OutErrorInfo(target).getLevel().getClass().getName()+" **" + ExceptUtil.stringify(OutErrorInfo(target).getThrowable());
	}
}