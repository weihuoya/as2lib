import org.as2lib.env.out.OutHandler;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.util.OutUtil;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 * @version 1.0
 */
class org.as2lib.env.out.handler.TraceHandler extends BasicClass implements OutHandler {
	/**
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function write(info:OutWriteInfo):Void {
		trace (OutUtil.stringifyWriteInfo(info));
	}
	
	/**
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function error(info:OutErrorInfo):Void {
		trace (OutUtil.stringifyErrorInfo(info));
	}
}