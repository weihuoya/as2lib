import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.holder.string.MapStringifier;
import org.as2lib.data.holder.string.StackStringifier;
import org.as2lib.data.holder.string.QueueStringifier;

/**
 * @author Simon Wacker
 */
class org.as2lib.data.holder.HolderConfig extends BasicClass {
	private static var mapStringifier:Stringifier = new MapStringifier();
	private static var stackStringifier:Stringifier = new StackStringifier();
	private static var queueStringifier:Stringifier = new QueueStringifier();
	
	private function HolderConfig(Void) {
	}
	
	public static function setMapStringifier(newStringifier:Stringifier):Void {
		mapStringifier = newStringifier;
	}
	
	public static function getMapStringifier(Void):Stringifier {
		return mapStringifier;
	}
	
	public static function setStackStringifier(newStringifier:Stringifier):Void {
		stackStringifier = newStringifier;
	}
	
	public static function getStackStringifier(Void):Stringifier {
		return stackStringifier;
	}
	
	public static function setQueueStringifier(newStringifier:Stringifier):Void {
		queueStringifier = newStringifier;
	}
	
	public static function getQueueStringifier(Void):Stringifier {
		return queueStringifier;
	}
}