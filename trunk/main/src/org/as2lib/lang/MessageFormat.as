import org.as2lib.core.BasicClass;
import org.as2lib.lang.DateFormat;
import org.as2lib.lang.NumberFormat;
import org.as2lib.data.holder.Properties;

/**
 * @author Martin Heidegger
 */
class org.as2lib.lang.MessageFormat extends BasicClass {
	
	private var dateFormat:DateFormat;
	private var numberFormat:NumberFormat;
	private var map:Array;
	private var messageLookup:Properties;
	
	public function MessageFormat(defaultMessageLookup:Properties, defaultNumberFormat:String, defaultDateFormat:String, store:Boolean) {
		dateFormat = new DateFormat(defaultDateFormat, defaultMessageLookup);
		numberFormat = new NumberFormat(defaultNumberFormat);
		messageLookup = defaultMessageLookup;
		if (store) {
			map = new Array();
		}
	}
	
	public function setNumberFormat(numberFormat:NumberFormat):Void {
		this.numberFormat = numberFormat;
	}
	
	public function setDateFormat(dateFormat:DateFormat):Void {
		this.dateFormat = dateFormat;
	}
	
	public function format(string:String, args:Array):String {
		var i:Number;
		var tokens:Array;
		var result:String = "";
		if (map) {
			tokens = map[string];
			if (!tokens) {
				tokens = getTokens(string);
				map[string] = tokens;
			}
		} else {
			tokens = getTokens(string);
		}
		for (i=0; i<tokens.length; i++) {
			var token = tokens[i];
			if (typeof token == "string") {
				result += tokens[i];
			} else {
				var num:Number = Number(token[0]);
				if (!num && token[0].length > 1) {
					var args2:Array = token.slice(1);
					var args3:Array = [];
					var content:String = messageLookup.getProp(token[0]);
					if (content != string) {
						for (var j:String in args2) {
							if (args[args2[j]]) {
								args3[j] = args[args2[j]];
							} else {
								args3[j] = j;
							}
						}
						result += this.format(content, args3);
					}
				} else {
					var arg = args[num];
					if (token.length == 1) {
						if (arg) {
							result += arg;
						}
					} else {
						var type:String = token[1].toLowerCase();
						var format:String = token[2];
						if (type == "date") {
							if (arg instanceof Date) {
								result += dateFormat.format(arg, format);							
							}
						} else if (type == "number") {
							if (arg instanceof Number || typeof arg == "number") {
								result += numberFormat.format(arg, format, token[3].toLowerCase(), token[4].toLowerCase(), token[5].toLowerCase());
							}
						}
					}
				}
			}
		}
		return result;
	}
	
	private function getTokens(string):Array {
		var result:Array = new Array();
		var tokenStart:Number = 0;
		var i:Number;
		var escape:Boolean = false;
		for (i=0; i<string.length; i++) {
			var c:String = string.charAt(i);
			if (c == "'") {
				escape = true;
				if (i == string.length-1) {
					result.push(string.substring(tokenStart));
				}
			} else {
				if (!escape) {
					if (c == "{" ) {
						result.push(string.substring(tokenStart,i));
						tokenStart = i+1;
					} else if (c == "}") {
						result.push(string.substring(tokenStart,i).split(","));
						tokenStart = i+1;
					} else if (i == string.length-1) {
						result.push(string.substring(tokenStart));
					} 
				}
				escape = false;
			}
			
		}
		return result;
	}
}