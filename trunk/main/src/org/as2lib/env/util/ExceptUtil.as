import org.as2lib.core.BasicClass;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.except.ExceptConfig;

/**
 * ExceptUtil contains the sourced out functionality used by class of the except
 * package.
 */
class org.as2lib.env.util.ExceptUtil extends BasicClass {
	/** 
	 * Private constructor 
	 */
	private function ExceptUtil(Void) {
	}
	
	/**
	 * Stringifies Throwables. Uses the ExceptConfig#getStringifier() operation
	 * to do the job.
	 *
	 * @param throwable the Throwable to be stringified
	 * @return the stringified Throwable
	 */
	public static function stringify(throwable:Throwable):String {
		return ExceptConfig.getStringifier().execute(throwable);
	}
}