import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.env.util.ExceptUtil;

class org.as2lib.env.out.string.ErrorStringifier extends BasicClass implements Stringifier {
	public function execute(target):String {
		return "** "+OutErrorInfo(target).getLevel().getClass().getName()+" **" + ExceptUtil.stringify(OutErrorInfo(target).getThrowable());
	}
}