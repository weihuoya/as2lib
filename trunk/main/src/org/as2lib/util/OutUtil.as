import org.as2lib.basic.BasicClass;
import org.as2lib.basic.out.OutWriteInfo;
import org.as2lib.basic.out.OutErrorInfo;

class org.as2lib.util.OutUtil extends BasicClass {
	private function OutUtil(Void) {
	}
	
	public static function getWriteString(info:OutWriteInfo):String {
		return (info.getLevel().getClass().getName() + ":\n"
				+ info.getMessage());
	}
	
	public static function getErrorString(info:OutErrorInfo):String {
		return (info.getLevel().getClass().getName() + ":\n"
				+ info.getException().getMessage());
	}
}