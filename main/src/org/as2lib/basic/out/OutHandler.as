import org.as2lib.basic.event.EventListener;
import org.as2lib.basic.out.OutWriteInfo;
import org.as2lib.basic.out.OutErrorInfo;

/**
 * @author Simon Wacker
 * @version 1.0
 */
interface org.as2lib.basic.out.OutHandler extends EventListener {
	/**
	 * Writes a message to the output target.
	 * @param message
	 */
	public function write(info:OutWriteInfo):Void;
	
	/**
	 * Writes the String appearance of an exception to the output target.
	 * @param exception
	 */
	public function error(info:OutErrorInfo):Void;
}