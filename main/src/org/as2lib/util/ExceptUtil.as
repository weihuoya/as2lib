import org.as2lib.basic.BasicClass;
import org.as2lib.except.ThrowableStringifier;
import org.as2lib.basic.string.Stringifier;
import org.as2lib.except.Throwable;

class org.as2lib.util.ExceptUtil extends BasicClass {
	private static var stringifier:Stringifier = new ThrowableStringifier();
	
	private function ThrowUtil(Void) {
	}
	
	public static function setStringifier(newStringifier:Stringifier):Void {
		stringifier = newStringifier;
	}
	
	public static function stringify(throwable:Throwable):String {
		return stringifier.execute(Object(throwable));
	}
}