import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.holder.string.MapStringifier;
import org.as2lib.data.holder.string.StackStringifier;
import org.as2lib.data.holder.string.QueueStringifier;

/**
 * HolderConfig is the fundamental configuration file for all classes residing
 * in the org.as2lib.data.holder package.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.HolderConfig extends BasicClass {
	/** Used to stringify Maps. */
	private static var mapStringifier:Stringifier = new MapStringifier();
	
	/** Used to stringify Stacks. */
	private static var stackStringifier:Stringifier = new StackStringifier();
	
	/** Used to stringify Queues. */
	private static var queueStringifier:Stringifier = new QueueStringifier();
	
	/** 
	 * Private constructor.
	 */
	private function HolderConfig(Void) {
	}
	
	/**
	 * Sets the new Stringifier used to stringify Maps.
	 *
	 * @param stringifier the new Map Stringifier
	 */
	public static function setMapStringifier(newStringifier:Stringifier):Void {
		mapStringifier = newStringifier;
	}
	
	/**
	 * Returns the currently used Stringifier used to stringify Maps.
	 *
	 * @return the currently used Map Stringifier
	 */
	public static function getMapStringifier(Void):Stringifier {
		return mapStringifier;
	}
	
	/**
	 * Sets the new Stringifier used to stringify Stacks.
	 *
	 * @param stringifier the new Stack Stringifier
	 */
	public static function setStackStringifier(newStringifier:Stringifier):Void {
		stackStringifier = newStringifier;
	}
	
	/**
	 * Returns the currently used Stringifier used to stringify Stacks.
	 *
	 * @return the currently used Stack Stringifier
	 */
	public static function getStackStringifier(Void):Stringifier {
		return stackStringifier;
	}
	
	/**
	 * Sets the new Stringifier used to stringify Queues.
	 *
	 * @param stringifier the new Queue Stringifier
	 */
	public static function setQueueStringifier(newStringifier:Stringifier):Void {
		queueStringifier = newStringifier;
	}
	
	/**
	 * Returns the currently used Stringifier used to stringify Queues.
	 *
	 * @return the currently used Queues Stringifier
	 */
	public static function getQueueStringifier(Void):Stringifier {
		return queueStringifier;
	}
}