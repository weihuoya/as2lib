import org.as2lib.basic.out.OutHandler;
import org.as2lib.basic.out.OutInfo;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.handler.TraceHandler implements OutHandler {
	/**
	 * @see org.as2lib.basic.out.OutHandler
	 */
	public function write(info:OutInfo):Void {
		trace (info.getMessage());
	}
	
	/**
	 * @see org.as2lib.basic.out.OutHandler
	 */
	public function error(info:OutInfo):Void {
		//trace (ExceptionUtil.toString(info.getException()));
	}
}