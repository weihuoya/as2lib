import org.as2lib.env.out.Out;
import org.as2lib.env.out.OutAccess;

/**
 * Basic Config File for all Classes.
 * 
 * @autor Martin Heidegger
 * @date 24.04.2004
 */
class org.as2lib.Config {
	private static var out:OutAccess = new Out();
	public static function setOut(to:OutAccess):Void {
		out = to;
	}
	public static function getOut(Void):OutAccess {
		return out;
	}
}