import org.as2lib.basic.out.OutHandler;
import org.as2lib.basic.out.OutInfo;
import org.as2lib.basic.event.EventInfo;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.handler.TraceHandler implements OutHandler {
	/**
	 * @see org.as2lib.basic.out.OutHandler
	 */
	public function write(info:EventInfo):Void {
		trace (OutInfo(info).getMessage());
	}
	
	/**
	 * @see org.as2lib.basic.out.OutHandler
	 */
	public function error(info:EventInfo):Void {
		//trace (ExceptionUtil.toString(OutInfo(info).getException()));
	}
}