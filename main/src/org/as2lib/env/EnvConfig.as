import org.as2lib.env.out.Out;
import org.as2lib.env.out.OutAccess;

/**
 * Rudimentary Config File.
 */
class org.as2lib.env.EnvConfig {
	private static var out:OutAccess = new Out();
	
	public static function setOut(newOut:OutAccess):Void {
		out = newOut;
	}
	
	public static function getOut(Void):OutAccess {
		return out;
	}
}