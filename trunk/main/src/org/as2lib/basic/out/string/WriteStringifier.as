import org.as2lib.basic.BasicClass;
import org.as2lib.basic.string.Stringifier;
import org.as2lib.util.ReflectUtil;
import org.as2lib.basic.out.info.OutWriteInfo;

class org.as2lib.basic.out.string.WriteStringifier extends BasicClass implements Stringifier {
	public function execute(target:Object):String {
		return "Write: " + OutWriteInfo(target).getMessage();
	}
}