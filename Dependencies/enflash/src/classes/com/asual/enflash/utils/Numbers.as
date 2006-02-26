class com.asual.enflash.utils.Numbers {

	/**
	 * Converts a number to a hexadecimal string value.
	 * 
	 * @param number The number to be converted
	 * @return Hexadecimal representation of the number
	 */	
	public static function hexString(number:Number):String {
		var string = number.toString(16)
		while (string.length < 6){
			string = "0" + string;
		}
		return string;
	}

	/**
	 * Inverts a number.
	 * 
	 * @param number The number to be inverted
	 * @return The iverted value
	 */
	public static function invert(number:Number):Number {
		return -number;
	}
	
}