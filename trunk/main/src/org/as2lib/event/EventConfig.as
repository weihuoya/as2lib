import org.as2lib.core.BasicClass;
import org.as2lib.out.OutAccess;
import org.as2lib.util.ObjectUtil;
import org.as2lib.Config;

class org.as2lib.event.EventConfig extends BasicClass {
	private static var out:OutAccess;
	
	private function EventConfig(Void) {
	}
	
	public static function setOut(newOut:OutAccess):Void {
		out = newOut;
	}
	
	public static function getOut(Void):OutAccess {
		if (ObjectUtil.isEmpty(out)) {
			return Config.getOut();
		}
		return out;
	}
}