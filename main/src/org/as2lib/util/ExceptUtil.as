import org.as2lib.core.BasicClass;
import org.as2lib.except.Throwable;
import org.as2lib.except.ExceptConfig;

class org.as2lib.util.ExceptUtil extends BasicClass {
	private function ExceptUtil(Void) {
	}

	public static function stringify(throwable:Throwable):String {
		return ExceptConfig.getStringifier().execute(throwable);
	}
}