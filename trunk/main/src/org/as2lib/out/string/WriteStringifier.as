import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.util.ReflectUtil;
import org.as2lib.out.info.OutWriteInfo;

class org.as2lib.out.string.WriteStringifier extends BasicClass implements Stringifier {
	public function execute(target:Object):String {
		return "Write: " + OutWriteInfo(target).getMessage();
	}
}