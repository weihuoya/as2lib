import org.as2lib.out.Out;
import org.as2lib.out.OutAccess;

/**
 * Rudimentary Config File.
 */
class org.as2lib.Config {
	private static var out:OutAccess = new Out();
	
	public static function setOut(newOut:OutAccess):Void {
		out = newOut;
	}
	
	public static function getOut(Void):OutAccess {
		return out;
	}
}