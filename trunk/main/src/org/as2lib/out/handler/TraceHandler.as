import org.as2lib.out.OutHandler;
import org.as2lib.out.info.OutWriteInfo;
import org.as2lib.out.info.OutErrorInfo;
import org.as2lib.event.EventInfo;
import org.as2lib.util.OutUtil;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.out.handler.TraceHandler extends BasicClass implements OutHandler {
	/**
	 * @see org.as2lib.out.OutHandler
	 */
	public function write(info:OutWriteInfo):Void {
		trace (OutUtil.stringifyWriteInfo(info));
	}
	
	/**
	 * @see org.as2lib.out.OutHandler
	 */
	public function error(info:OutErrorInfo):Void {
		trace (OutUtil.stringifyErrorInfo(info));
	}
}