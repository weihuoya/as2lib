import org.as2lib.core.BasicClass;
import org.as2lib.env.out.OutAccess;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.EnvConfig;

class org.as2lib.env.event.EventConfig extends BasicClass {
	private static var out:OutAccess;
	
	private function EventConfig(Void) {
	}
	
	public static function setOut(newOut:OutAccess):Void {
		out = newOut;
	}
	
	public static function getOut(Void):OutAccess {
		if (ObjectUtil.isEmpty(out)) {
			return EnvConfig.getOut();
		}
		return out;
	}
}