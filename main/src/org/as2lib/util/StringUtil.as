import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.core.BasicClass;


/**
 * Basic String Util Class, should have the Same Functionality like the base FString Class (flashforum.de Teamwork)
 *
 * @autor Martin Heidegger, Simon Wacker, Flashforum.de Community
 */
class org.as2lib.util.StringUtil extends BasicClass {
	/**
	 * Private Constructor. (not instanceable)
	 */
	private function StringUtil(Void) {
	}
	
	/**
	 * Replaces all occurencies of a string within a string by another string.charAt
	 * 
	 * @param String where the content should be replaced.
	 * @param Searchstring.
	 * @param Replacestring.
	 * @return String where all occurencies are replaced.
	 */
	public static function replace(string:String, what:String, to:String):String {
		return string.split(what).join(to);
	}
	
	/**
	 * Removes all empty characters at the beginning and at the end of a string.
	 * Removed characters: Space " ", Line Forwards "\n", Extended Line Fowarding "\t\n".
	 * 
	 * @param String that should get trimmed.
	 * @return The applied string, trimmed.
	 */
	public static function trim(string:String):String {
		return leftTrim(rightTrim(string));
	}
	
	/**
	 * Removes all empty characters at the beginning of a string.
	 * Removed characters: Space " ", Line Forwards "\n", Extended Linde Forwarding "\t\n".
	 * 
	 * @param String that should get trimmed.
	 * @return The applied string, trimmed.
	 */
	public static function leftTrim(string:String):String {
		return leftTrimForChars(string, "\n\t\n ");
	}
	
	public static function leftTrimForChars(string:String, chars:String):String {
		var from:Number = 0;
		var to:Number = string.length;
		while (from < to && chars.indexOf(string.charAt(from)) >= 0){
			from++;
		}
		return (from > 0 ? string.substr(from, to) : string);
	}

	/**
	 * Removes all empty characters at the beginning of a string.
	 * Removed characters: Space " ", Line Forwards "\n", Extended Linde Forwarding "\t\n".
	 * 
	 * @param String that should get trimmed.
	 * @return The applied string, trimmed.
	 */	
	public static function rightTrim(string:String):String {
		return rightTrimForChars(string, "\n\t\n ");
	}
	
	public static function rightTrimForChars(string:String, chars:String):String {
		var from:Number = 0;
		var to:Number = string.length - 1;
		while (from < to && chars.indexOf(string.charAt(to)) >= 0) {
			to--;
		}
		return (to >= 0 ? string.substr(from, to+1) : string);
	}
	
	public static function leftTrimForChar(string:String, char:String):String {
		return leftTrimForChars(string, char);
	}
	
	public static function rightTrimForChar(string:String, char:String):String {
		return rightTrimForChars(string, char);
	}

	public static function checkEmail(string:String):Boolean {
		// The min Size of an Email is 6 Chars "a@b.cc";
		if (string.length < 6) {
			return false;
		}
		// There must be exact one @ in the Content
		if (string.split('@').length > 2 || string.indexOf('@') < 0) {
			return false;
		}
		// There must be min one . in the Content before the last @
		if (string.lastIndexOf('@') > string.lastIndexOf('.')) {
			return false;
		}
		// There must be min two Characters after the last .
		if (string.lastIndexOf('.') > string.length - 3) {
			return false;
		}
		// There must be min two Characters between the @ and the last .
		if (string.lastIndexOf('.') <= string.lastIndexOf('@') + 1) {
			return false;
		}
		return true;
	}
	
	public static function assureLength(string:String, length:Number):Boolean {
		if (length < 0 || (!length && length !== 0)) {
			throw new IllegalArgumentException("The Second Attribute [" + length + "] must be bigger or equas 0.", 
												eval("th" + "is"), 
												arguments);
		}
		return (string.length >= length);
	}
	
	public static function contains(string:String, chars:String):Boolean {
		for (var i:Number = 0; i < chars.length; i++) {
			if (string.indexOf(chars.charAt(i)) >= 0) {
				return true;
			}
		}
		return false;
	}
	
	public static function beginsWith(string:String, chars:String):Boolean {
		if (string.indexOf(chars) == 0) {
			return true;
		}
		return false;
	}
}