import org.as2lib.env.event.EventListener;
import org.as2lib.core.BasicClass;
/**
 * Smallest form of a Call (used by all Tests in this package).
 * 
 * @autor Martin Heideggger
 * @version 1.0
 */
class test.speed.broadcasting.ExampleCall extends BasicClass implements EventListener {
	/** Internal counter (just to do something */
	public static var counter:Number = 0;
	
	/**
	 * Executes a call.
	 */
	public function call(Void):Void {
		counter++;
	}
}