import org.as2lib.core.BasicClass;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.out.string.WriteStringifier;
import org.as2lib.env.out.string.ErrorStringifier;
import org.as2lib.env.out.OutConfig;

/**
 * OutUtil contains the sourced out functionality used by classes of the out
 * package.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.util.OutUtil extends BasicClass {
	/** 
	 * Private constructor 
	 */
	private function OutUtil(Void) {
	}
	
	/**
	 * Stringifies an OutWriteInfo instance using the Stringifier returned by
	 * the OutConfig#getWriteStringifier() operation.
	 *
	 * @param info the OutWriteInfo to be stringified
	 * @return the stringified OutWriteInfo
	 */
	public static function stringifyWriteInfo(info:OutWriteInfo):String {
		return OutConfig.getWriteStringifier().execute(info);
	}
	
	/**
	 * Stringifies an OutErrorInfo instance using the Stringifier returned by
	 * the OutConfig#getErrorStringifier() operation.
	 *
	 * @param info the OutErrorInfo to be stringified
	 * @return the stringified OutErrorInfo
	 */
	public static function stringifyErrorInfo(info:OutErrorInfo):String {
		return OutConfig.getErrorStringifier().execute(info);
	}
}