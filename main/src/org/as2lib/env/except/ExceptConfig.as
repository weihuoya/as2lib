import org.as2lib.core.BasicClass;
import org.as2lib.env.except.ThrowableStringifier;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.out.OutAccess;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.EnvConfig;

class org.as2lib.env.except.ExceptConfig extends BasicClass {
	private static var stringifier:Stringifier = new ThrowableStringifier();
	private static var out:OutAccess;
	
	private function ExceptConfig(Void) {
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
	
	public static function setStringifier(newStringifier:Stringifier):Void {
		stringifier = newStringifier;
	}
	
	public static function getStringifier(Void):Stringifier {
		return stringifier;
	}
}