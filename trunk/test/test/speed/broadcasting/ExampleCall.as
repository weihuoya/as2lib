import org.as2lib.basic.event.EventListener;
import org.as2lib.basic.BasicClass;
/**
 * Smallest form of a Call (used by all Tests in this package).
 * 
 * @autor Martin Heideggger
 * @version 1.0
 */
class broadcasting.ExampleCall extends BasicClass implements EventListener {
	/** Internal counter (just to do something */
	public static var counter:Number = 0;
	
	/**
	 * Executes a call.
	 */
	public function call(Void):Void {
		counter++;
	}
}