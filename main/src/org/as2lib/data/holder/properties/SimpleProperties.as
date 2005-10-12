import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Properties;
import org.as2lib.util.StringUtil;

/**
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.data.holder.properties.SimpleProperties extends BasicClass implements Properties {
	
	/** List that contains all properties. */
	private var l:Array;
	
	private static var escapeMap:Array = 
		["\\t", "\t", "\\n", "\n", "\\r", "\r", "\\\"", "\"", "\\\\", "\\", "\\'", "\'", "\\f", "\f"];
	
	function SimpleProperties() {
		l = new Array();
	}

	public function getProperty(key:String, defaultValue:String):String {
		var value:String = l[key];
		if (!value) {
			if (defaultValue) {
				return StringUtil.escape(defaultValue, escapeMap, false);
			}
			return key;
		}
		return value;
	}

	public function setProperty(key:String, value:String):Void {
		l[key] = StringUtil.escape(value, escapeMap, false);
	}
}