import org.as2lib.basic.event.EventListener;
import org.as2lib.basic.out.OutInfo;

/**
 * @author Simon Wacker
 * @version 1.0
 */
interface org.as2lib.basic.out.OutHandler extends EventListener {
	/**
	 * Writes a message to the output target.
	 * @param message
	 */
	public function write(info:OutInfo):Void;
	
	/**
	 * Writes the String appearance of an exception to the output target.
	 * @param exception
	 */
	public function error(info:OutInfo):Void;
}