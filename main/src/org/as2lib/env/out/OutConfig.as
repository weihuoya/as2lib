import org.as2lib.core.BasicClass;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.out.string.WriteStringifier;
import org.as2lib.env.out.string.ErrorStringifier;

class org.as2lib.env.out.OutConfig extends BasicClass {
	private static var writeStringifier:Stringifier = new WriteStringifier();
	private static var errorStringifier:Stringifier = new ErrorStringifier();
	
	private function OutConfig(Void) {
	}
	
	public static function setWriteStringifier(newStringifier:Stringifier):Void {
		writeStringifier = newStringifier;
	}
	
	public static function getWriteStringifier(Void):Stringifier {
		return writeStringifier;
	}
	
	public static function setErrorStringifier(newStringifier:Stringifier):Void {
		errorStringifier = newStringifier;
	}
	
	public static function getErrorStringifier(Void):Stringifier {
		return errorStringifier;
	}
}