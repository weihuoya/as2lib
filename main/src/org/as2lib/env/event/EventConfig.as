import org.as2lib.core.BasicClass;
import org.as2lib.env.out.OutAccess;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.EnvConfig;

/**
 * EventConfig contains operations to configure functionality from the org.as2lib.env.event
 * package.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.EventConfig extends BasicClass {
	/** The OutAccess instance used by classes of the org.as2lib.env.event package. */
	private static var out:OutAccess;
	
	/**
	 * Private constructor.
	 */
	private function EventConfig(Void) {
	}
	
	/**
	 * Sets a new OutAccess instance.
	 *
	 * @param out the new OutAcces instance
	 */
	public static function setOut(newOut:OutAccess):Void {
		out = newOut;
	}
	
	/**
	 * Returns the OutAccess instance currently used. If no OutAccess instance
	 * has been set manually the OutAccess instance returned by EnvConifg#getOut()
	 * will be used.
	 *
	 * @return the OutAccess instance used
	 */
	public static function getOut(Void):OutAccess {
		if (ObjectUtil.isEmpty(out)) {
			return EnvConfig.getOut();
		}
		return out;
	}
}