/*
* Basic String Util Class, should have the Same Functionality like the base FString Class (flashforum.de Teamwork)
*/

class de.flashforum.util.StringUtil {
	
	static function replace(content:String, wath:String, to:String ):String {
		if(typeof content == "string") {
			var tempArray:Array;
			tempArray = content.split(wath);
			content = tempArray.join(to);
		}
		return(content);
	}
	
	static function leftTrimForChars (content:String, chars:String ):String {
		var from:Number, to:Number;
		from = 0;
		to = content.length;
		while( from < to && chars.indexOf(content.charAt(from)) >= 0){
			from++;
		}
		from > 0 ? content = content.substr(from, to) : false;
		return(content);
	}
	
	static function leftTrimForChar (content:String, char:String ):String {
		return(leftTrimForChars(content, char));
	}
	
	static function trim (content:String):String {
		content = rightTrim(content);
		content = leftTrim(content);
		return(content);
	}
	
	static function rightTrimForChars (content:String, chars:String):String {
		var from:Number, to:Number;
		from = 0;
		to = content.length-1;
		while( from < to && chars.indexOf(content.charAt(to)) >= 0) {
			to--;
		}
		to >= 0 ? content = content.substr(from, to+1) : false;
		return(content);
	}
	
	static function rightTrimForChar (content:String, char:String ):String {
		return(rightTrimForChars(content, char));
	}
	
	static function leftTrim (content:String):String {
		return(leftTrimForChars(content, "\n\t\n "));
	}
	
	static function rightTrim (content:String):String {
		return(rightTrimForChars(content, "\n\t\n "));
	}

	static function checkEmail(content:String):Boolean {
		// The min Size of an Email is 6 Chars "a@b.cc";
		if(content.length < 6 || content == undefined) {
			return(false);
		}
		// There must be exact one @ in the Content
		var myArray:Array = content.split('@');
		if(myArray.length > 2 || content.indexOf('@') < 0) {
			return(false);
		}
		// There must be min one . in the Content before the last @
		if(content.lastIndexOf('@') > content.lastIndexOf('.')) {
			return(false);
		}
		// There must be min two Characters after the last .
		if(content.lastIndexOf('.') > content.length-3) {
			return(false);
		}
		// There must be min two Characters between the @ and the last .
		if(content.lastIndexOf('.') <= content.lastIndexOf('@')+1) {
			return(false);
		}
		return(true);
	}
	
	static function checkLength(content:String, len:Number):Boolean {
		if(!content) {
			return(false);
		}
		if(len <= 0) {
			throw (new de.flashforum.exceptions.WrongArgumentException("The Second Attribute[length] has to be bigger than 0.", "de.flashforum.util.StringUtil", "checkLength", arguments));
		}
			
		if (content.length >= len) {
			return(true);
		} else {
			return(false);
		}
	}
	
	static function contains(content:String, chars:String):Boolean {
		for(var i=0; i<chars.length; i++) {
			if(content.indexOf(chars.charAt(i)) >= 0) {
				return(true);
			}
		}
		return(false);
	}
}