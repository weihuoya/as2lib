import org.as2lib.core.BasicClass;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.out.string.WriteStringifier;
import org.as2lib.env.out.string.ErrorStringifier;

/**
 * OutConfig is the main config class for the out package.
 *
 * @author OutConfig
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.out.OutConfig extends BasicClass {
	/** This Stringifier is used to stringify an OutWriteInfo. */
	private static var writeStringifier:Stringifier = new WriteStringifier();
	
	/** Stringifier used to stringify an OutErrorInfo. */
	private static var errorStringifier:Stringifier = new ErrorStringifier();
	
	/**
	 * Private constructor.
	 */
	private function OutConfig(Void) {
	}
	
	/**
	 * Sets the Stringifier used to stringify an OutWriteInfo.
	 * 
	 * @param stringifier the new Stringifier used to stringify an OutWriteInfo
	 */
	public static function setWriteStringifier(newStringifier:Stringifier):Void {
		writeStringifier = newStringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify an OutWriteInfo
	 *
	 * @return the write Stringifier
	 */
	public static function getWriteStringifier(Void):Stringifier {
		return writeStringifier;
	}
	
	/**
	 * Sets the Stringifier used to stringify an OutErrorInfo.
	 * 
	 * @param stringifier the new Stringifier used to stringify an OutErrorInfo
	 */
	public static function setErrorStringifier(newStringifier:Stringifier):Void {
		errorStringifier = newStringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify an OutErrorInfo
	 *
	 * @return the error Stringifier
	 */
	public static function getErrorStringifier(Void):Stringifier {
		return errorStringifier;
	}
}