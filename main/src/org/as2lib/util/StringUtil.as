/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.core.BasicClass;


/**
 * Container for a lot of different Methods to work with strings.
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 * @author Flashforum.de Community
 */
class org.as2lib.util.StringUtil extends BasicClass {
	/**
	 * Private Constructor. (not instantiateable)
	 */
	private function StringUtil(Void) {}
	
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
	
	/**
	 * Removes all characters at the beginning of a string that match to a set of characters.
	 * This method splits all characters(chars) and removes occurencies at at the beginning.
	 * 
	 * Example:
	 * <CODE>
	 *   trace(StringUtil.rightTrimForChars("ymoynkeym", "ym")); // oynkeym
	 *   trace(StringUtil.rightTrimForChars("monkey", "mo")); // nkey
	 *   trace(StringUtil.rightTrimForChars("monkey", "om")); // nkey
	 * </CODE>
	 * 
	 * @param string String that should get trimmed.
	 * @param chars Characters that should be trimmed.
	 * @return Trimmed string.
	 */
	public static function leftTrimForChars(string:String, chars:String):String {
		var from:Number = 0;
		var to:Number = string.length;
		while (from < to && chars.indexOf(string.charAt(from)) >= 0){
			from++;
		}
		return (from > 0 ? string.substr(from, to) : string);
	}
	
	/**
	 * Removes all characters at the end of a string that match to a set of characters.
	 * This method splits all characters(chars) and removes occurencies at at the end.
	 * 
	 * Example:
	 * <CODE>
	 *   trace(StringUtil.rightTrimForChars("ymoynkeym", "ym")); // ymoynke
	 *   trace(StringUtil.rightTrimForChars("monkey***", "*y")); // monke
	 *   trace(StringUtil.rightTrimForChars("monke*y**", "*y")); // monke
	 * </CODE>
	 * 
	 * @param string String that should get trimmed.
	 * @param chars Characters that should be trimmed.
	 * @return Trimmed string.
	 */
	public static function rightTrimForChars(string:String, chars:String):String {
		var from:Number = 0;
		var to:Number = string.length - 1;
		while (from < to && chars.indexOf(string.charAt(to)) >= 0) {
			to--;
		}
		return (to >= 0 ? string.substr(from, to+1) : string);
	}
	
	/**
	 * Removes all characters at the beginning that matches a character(char).
	 * 
	 * Example:
	 * <CODE>
	 *   trace(StringUtil.leftTrimForChar("yyyymonkeyyyy", "y"); // monkeyyyy
	 * </CODE>
	 * 
	 * @param string String that should get trimed by the right side.
	 * @param char Character that should be removed.
	 * @throws IllegalArgumentException if you try to remove more that one char.
	 * @return string trimmed at the beginning.
	 */
	public static function leftTrimForChar(string:String, char:String):String {if(char.length != 1) {
		throw new IllegalArgumentException("The Second Attribute char [" + char + "] must exactly one character.", 
												eval("th" + "is"), 
												arguments);
		}
		return leftTrimForChars(string, char);
	}
	
	/**
	 * Removes all characters at the end that matches a character(char).
	 * 
	 * Example:
	 * <CODE>
	 *   trace(StringUtil.rightTrimForChar("yyyymonkeyyyy", "y"); // yyyymonke
	 * </CODE>
	 * 
	 * @param string String that should get trimed by the right side.
	 * @param char Character that should be removed.
	 * @throws IllegalArgumentException if you try to remove more that one char.
	 * @return string trimmed at the end.
	 */
	public static function rightTrimForChar(string:String, char:String):String {
		if(char.length != 1) {
			throw new IllegalArgumentException("The Second Attribute char [" + char + "] must exactly one character.", 
												eval("th" + "is"), 
												arguments);
		}
		return rightTrimForChars(string, char);
	}
 
      /**
       * Validates a E-Mail adress to a predefined email pattern.
       * 
       * @param string string that should be a email adress.
       * @return true if the string matches the email pattern.
       */
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
	
	/**
	 * Assures that a string is bigger or equals a defined length.
	 * 
	 * @param string String that should be validated.
	 * @param length Length the string should be.
	 * @throws IllegalArgumentException if required length is smaller 0.
	 * @return true if the length of the string is bigger or equals the required length.
	 */
	public static function assureLength(string:String, length:Number):Boolean {
		if (length < 0 || (!length && length !== 0)) {
			throw new IllegalArgumentException("The Second Attribute [" + length + "] must be bigger or equals 0.", 
												eval("th" + "is"), 
												arguments);
		}
		return (string.length >= length);
	}
	
	/**
	 * Evaluates if a list of characters is contained in a string.
	 * This methods splits the searchstring(chars) and checks if any
	 * character is contained in another string(string).
	 * 
	 * Example:
	 * <CODE>
	 *   trace(StringUtil.contains("monkey", "kzj0")); // true
	 *   trace(StringUtil.contains("monkey", "yek")); // true
	 *   trace(StringUtil.contains("monkey", "a")); // false
	 * </CODE>
	 * 
	 * @param string String that should be checked if it contains any of the searchstring.
	 * @param chars Character String that contains a list of characters that should be checked if any character is contained.
	 * @return true if one of these characters are contained in string.
	 */
	public static function contains(string:String, chars:String):Boolean {
		for (var i:Number = 0; i < chars.length; i++) {
			if (string.indexOf(chars.charAt(i)) >= 0) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Evaluates if a String starts with another string.
	 * 
	 * @param string String that should be checked.
	 * @param searchString String that should be beginning with
	 * @return true if string starts with searchString else false.
	 */
	public static function startsWith(string:String, searchString:String):Boolean {
		if (string.indexOf(searchString) == 0) {
			return true;
		}
		return false;
	}
	
	/**
	 * Adds a space indent to a existing String.
	 * This method is useful for different kind of ASCII Output writing.
	 * It generates a dynamic size of space indents in front of every
	 * line inside a string.
	 * 
	 * Example:
	 * <CODE>
	 * var bigText = "My name is pretty important\n"
	 *              +"because i am a interesting\n"
	 *              +"small example for this\n"
	 *              +"documentation.";
	 * var result = StringUtil.addSpaceIndent(bigText, 3);
	 * </CODE>
	 * 
	 * Result contains now:
	 * <pre>   My name is pretty important
	 *    because i am a interesting
	 *    small example for this
	 *    documentation.</pre>
	 * 
	 * @param string String that contains lines that should get a space indent.
	 * @param indent Size of the Indent (will get floor'ed)
	 * @return String with a extended Indent.
	 */
	public static function addSpaceIndent(string:String, size:Number):String {
		var indentString:String = multiply(" ", size);
		return indentString+replace(string, "\n", "\n"+indentString);
	}
	
	/**
	 * Multiplies a String by factor to create long stringblocks.
	 * 
	 * Example:
	 * <CODE>
	 * trace("Result: "+StringUtil.multiply(">", 6); // Result: >>>>>>
	 * </CODE>
	 *
	 * @param string Source string to as base to multiply from.
	 * @param factor Times the string should be multiplied.
	 * @result The string multiplied in factor.
	 */
	public static function multiply(string:String, factor:Number):String {
		var result:String="";
		for(var i=0; i<factor; i++) {
			result += string;
		}
		return result;
	}
}