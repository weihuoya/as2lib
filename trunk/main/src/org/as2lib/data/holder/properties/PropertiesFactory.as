import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.properties.SimpleProperties;
import org.as2lib.data.holder.Properties;
import org.as2lib.data.type.MultilineString;
import org.as2lib.util.StringUtil;

/**
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.data.holder.properties.PropertiesFactory extends BasicClass {
	private static var instance:PropertiesFactory;
	
	public static function getInstance(Void):PropertiesFactory {
		if (!instance) {
			instance = new PropertiesFactory();
		}
		return instance;
	}
	
	private function PropertiesFactory(Void) {};
	
	public function createProperties(source:String):Properties {
		var result:Properties = new SimpleProperties();
		var lines:MultilineString = new MultilineString(source);
		var i:Number;
		var c:Number = lines.getLineCount();
		var formerKey:String;
		var formerValue:String;
		var useNextLine:Boolean = false;;
		
		for (i=0; i<c; i++) {
			var line:String = lines.getLine(i);
			
			// Trim the line
			line = StringUtil.trim(line);
			
			// Ignore Comments
			if ( line.indexOf("#") != 0 && line.indexOf("!") != 0 && line.length != 0) {
				
				// Line break processing
				if (useNextLine) {
					key = formerKey;
					value = formerValue+line;
					useNextLine = false;
				} else {
					var sep:Number = getSeperation(line);
					var key:String = StringUtil.rightTrim(line.substr(0,sep));
					var value:String = line.substring(sep+1);
					formerKey = key;
					formerValue = value;
				}
				
				// Trim the content
				value = StringUtil.leftTrim(value);
				
				// Allow normal lines
				if (value.charAt(value.length-1) == "\\") {
					value = value.substring(0, value.length-2);
					useNextLine = true;
				} else {
					// Commit Property
					result.setProperty(key, value);
				}
			}
		}
		return result;
	}
	
	private function getSeperation(line:String):Number {
		var i:Number;
		var l:Number = line.length;
		for (i=0; i<l; i++) {
			var c:String = line.charAt(i);
			if (c == "'") {
				i++;
			} else {
				if (c == ":" || c == "=" || c == "	") break;
			}
		}
		return ( (i == l) ? line.length : i );
	}
	
}