class com.asual.enflash.utils.Strings {

	/**
	 * Replaces a part or multiple parts of a string with a new value.
	 * 
	 * @param string The string that will be processed
	 * @param find The value that will be replaced
	 * @param replace The new value that will replace the old one
	 * @param sensitive (optional) Case-sensitive replacement
	 * @param number (optional) The number of replacements
	 * @return The modified string
	 */	
	public static function replace(string:String, find:String, replace:String, sensitive:Boolean, number:Number):String {

		var temp:String = "";
		
		if (sensitive == undefined) sensitive = true;		
		
		if (number != undefined){

			var s:Number;
			
			if (sensitive) {

				while (((s = string.indexOf(find)) != -1) && number > 0){
					temp += string.substr(0,s) + replace;
					string = string.substr(s + find.length, string.length);
					number--;
				}
				return temp + string;

			} else {

				while (((s = string.indexOf(find.toUpperCase())) != -1) && number > 0){
					temp += string.substr(0,s) + replace.toUpperCase();
					string = string.substr(s + find.length, string.length);
					number--;
				}
				
				while (((s = string.indexOf(find.toLowerCase())) != -1) && number > 0){
					temp += string.substr(0,s) + replace.toLowerCase();
					string = string.substr(s + find.length, string.length);
					number--;
				}
				
				return temp + string;				
			}

		} else {
			
			if (sensitive) {
				return string.split(find).join(replace);
			} else {
				temp = string.split(find.toLowerCase()).join(replace);
				temp = temp.split(find.toUpperCase()).join(replace);
				return temp;
			}
		}
	}

	/**
	 * Removes HTML tags from a string.
	 * 
	 * @param string The string that will be processed
	 * @return The modified string
	 */
	public static function removeHTML(string:String):String {
		
		if (string.length == 0) return string;
		
		var temp:String = "";
		var s:Number;
		
		while((s = string.indexOf("<")) != -1) {
			temp += string.substr(0,s);
			string = string.substr(string.indexOf(">") + 1, string.length);
		}
		
		return temp + string;
	}
}