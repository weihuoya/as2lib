import org.as2lib.basic.out.OutHandler;
import org.as2lib.basic.out.OutWriteInfo;
import org.as2lib.basic.out.OutErrorInfo;
import org.as2lib.basic.event.EventInfo;
import org.as2lib.util.OutUtil;
import org.as2lib.basic.BasicClass;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.handler.TraceHandler extends BasicClass implements OutHandler {
	/**
	 * @see org.as2lib.basic.out.OutHandler
	 */
	public function write(info:OutWriteInfo):Void {
		trace (OutUtil.getWriteString(info));
	}
	
	/**
	 * @see org.as2lib.basic.out.OutHandler
	 */
	public function error(info:OutErrorInfo):Void {
		trace (OutUtil.getErrorString(info));
	}
}