class com.asual.enflash.utils.TextFields {

	/**
	 * Reduces the content of a textfield in order to fit inside the given 
	 * width by adding three dots at the end.
	 * 
	 * @param textfield The textfield that will be processed
	 * @param buffer (optional) The accuracy of the reducement
	 */
	public static function reduce(textfield:TextField, buffer:Number):Void {

		if (buffer == undefined) buffer = 4;
	
		if (textfield._width == 0 || textfield._width > (textfield.textWidth + buffer)) return;
	
		var str = textfield.text;
		var i = str.length;
		while ((i-- > -1) && (textfield.textWidth + buffer > textfield._width)) {
			str = str.substring(0,str.length-1);
			textfield.text = str + "...";
		}
	}
}