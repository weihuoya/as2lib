import org.as2lib.core.BasicClass;
import org.as2lib.out.info.OutWriteInfo;
import org.as2lib.out.info.OutErrorInfo;
import org.as2lib.core.string.Stringifier;
import org.as2lib.out.string.WriteStringifier;
import org.as2lib.out.string.ErrorStringifier;

class org.as2lib.out.OutConfig extends BasicClass {
	private static var writeStringifier:Stringifier = new WriteStringifier();
	private static var errorStringifier:Stringifier = new ErrorStringifier();
	
	private function OutConfig(Void) {
	}
	
	public static function stringifyWriteInfo(info:OutWriteInfo):String {
		return writeStringifier.execute(info);
	}
	
	public static function stringifyErrorInfo(info:OutErrorInfo):String {
		return errorStringifier.execute(info);
	}
	
	public static function setWriteStringifier(newStringifier:Stringifier):Void {
		writeStringifier = newStringifier;
	}
	
	public static function setErrorStringifier(newStringifier:Stringifier):Void {
		errorStringifier = newStringifier;
	}
}