import org.as2lib.env.event.EventListener;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.out.info.OutErrorInfo;

/**
 * OutHandler is the base interface for all concrete OutHandlers. OutHandlers are used 
 * to write information to the output target. The OutHandler distinguishes between two 
 * kinds of information. First the normal OutWriteInfo which contains a message as a String
 * and second the OutErrorInfo which contains a Throwable. If you wanna write out a normal
 * String you use the operation #write(OutWriteInfo). If you wanna write out a Throwable
 * you use the operation #error(OutErrorInfo). The operation #error(OutErrorInfo) normally
 * gets only used when a Throwable has been thrown.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.out.OutHandler extends EventListener {
	/**
	 * Writes information obtained from the OutWriteInfo parameter as well as additional 
	 * information to the output target. It is not prescribed which information will be 
	 * written. Hence it depends on the concrete OutHandler.
	 *
	 * @param info the OutWriteInfo instance containing the base information
	 */
	public function write(info:OutWriteInfo):Void;
	
	/**
	 * Writes information obtained from the OutErrorInfo parameter as well as additional 
	 * information to the output target. It is not prescribed which information will be 
	 * written and how the Throwable will be stringified. Hence it depends on the concrete 
	 * OutHandler.
	 *
	 * @param info the OutErrorInfo instance containing the base information
	 */
	public function error(info:OutErrorInfo):Void;
}