import org.as2lib.core.BasicClass;
import org.as2lib.except.ThrowableStringifier;
import org.as2lib.core.string.Stringifier;
import org.as2lib.except.Throwable;
import org.as2lib.out.OutAccess;
import org.as2lib.util.ObjectUtil;
import org.as2lib.Config;

class org.as2lib.except.ExceptConfig extends BasicClass {
	private static var stringifier:Stringifier = new ThrowableStringifier();
	private static var out:OutAccess;
	
	private function ExceptConfig(Void) {
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
	
	public static function setStringifier(newStringifier:Stringifier):Void {
		stringifier = newStringifier;
	}
	
	public static function getStringifier(Void):Stringifier {
		return stringifier;
	}
}