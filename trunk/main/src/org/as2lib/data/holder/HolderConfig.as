import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.holder.string.MapStringifier;
import org.as2lib.data.holder.string.StackStringifier;

/**
 * @author Simon Wacker
 */
class org.as2lib.data.holder.HolderConfig extends BasicClass {
	private static var hashMapStringifier:Stringifier;
	private static var mapStringifier:Stringifier = new MapStringifier();
	private static var stackStringifier:Stringifier = new StackStringifier();
	
	private function HolderConfig(Void) {
	}
	
	public static function setMapStringifier(newStringifier:Stringifier):Void {
		mapStringifier = newStringifier;
	}
	
	public static function getMapStringifier(Void):Stringifier {
		return mapStringifier;
	}
	
	public static function setHashMapStringifier(newStringifier:Stringifier):Void {
		hashMapStringifier = newStringifier;
	}
	
	public static function getHashMapStringifier(Void):Stringifier {
		if (ObjectUtil.isEmpty(hashMapStringifier)) {
			return getMapStringifier();
		}
		return hashMapStringifier;
	}
	
	public static function setStackStringifier(newStringifier:Stringifier):Void {
		stackStringifier = newStringifier;
	}
	
	public static function getStackStringifier(Void):Stringifier {
		return stackStringifier;
	}
}