import org.as2lib.core.BasicClass;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.except.ExceptConfig;

class org.as2lib.env.util.ExceptUtil extends BasicClass {
	private function ExceptUtil(Void) {
	}

	public static function stringify(throwable:Throwable):String {
		return ExceptConfig.getStringifier().execute(throwable);
	}
}