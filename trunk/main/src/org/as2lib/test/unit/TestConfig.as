import org.as2lib.env.out.OutAccess;
import org.as2lib.Config;

/**
 * Config File for unit TestcaseSystem.
 * This file contains all configuration parameters.
 * 
 * @autor Martin Heidegger
 * @date 24.04.2004
 */
class org.as2lib.test.unit.TestConfig {
	/** The OutAccess instance for the testcase system. */
	private static var out:OutAccess;
	
	/**
	 * Sets the OutAccess Instance of the config.
	 * 
	 * @param Out instance for this config.
	 */
	public static function setOut(to:OutAccess):Void {
		out = to;
	}
	
	/**
	 * Evaluates and returns the Out Configurations.
	 * 
	 * @return Defined OutAccess instance.
	 */
	public static function getOut(Void):OutAccess {
		if(out) {
			return out;
		}
		return Config.getOut();
	}
}