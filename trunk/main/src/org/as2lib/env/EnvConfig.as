import org.as2lib.Config;
import org.as2lib.core.BasicClass;
import org.as2lib.env.out.Out;
import org.as2lib.env.out.OutAccess;

/**
 * EnvConfig is the fundamental configuration class for all classes in the env
 * package.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.EnvConfig extends BasicClass {
	/** The OutAccess instance basically used by classes in the env package to do their output. */
	private static var out:OutAccess;
	
	/**
	 * Sets a new OutAccess instance.
	 *
	 * @param out the new OutAcces instance
	 */
	public static function setOut(newOut:OutAccess):Void {
		out = newOut;
	}
	
	/**
	 * Returns a OutAccess instance.
	 *
	 * @return the OutAccess instance
	 */
	public static function getOut(Void):OutAccess {
		if(out) {
			return out;
		}
		return Config.getOut();
	}
}