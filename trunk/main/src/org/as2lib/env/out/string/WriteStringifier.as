import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.info.OutWriteInfo;

class org.as2lib.env.out.string.WriteStringifier extends BasicClass implements Stringifier {
	public function execute(target):String {
		return "** "+OutWriteInfo(target).getLevel().getClass().getName()+" **" + OutWriteInfo(target).getMessage();
	}
}