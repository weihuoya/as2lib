import org.as2lib.env.out.Out;
import org.as2lib.env.out.OutAccess;

/**
 * Basic configuration class for all classes.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.Config {
	/** The OutAccess instance basically used by all classes to do their output. */
	private static var out:OutAccess = new Out();
	
	/**
	 * Sets a new OutAccess instance.
	 *
	 * @param out the new OutAcces instance
	 */
	public static function setOut(to:OutAccess):Void {
		out = to;
	}
	
	/**
	 * Returns the OutAccess instance currently used.
	 *
	 * @return the OutAccess instance used
	 */
	public static function getOut(Void):OutAccess {
		return out;
	}
}