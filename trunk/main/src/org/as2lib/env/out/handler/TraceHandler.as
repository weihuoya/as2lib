import org.as2lib.env.out.OutHandler;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.out.info.OutErrorInfo;
import org.as2lib.env.event.EventInfo;
import org.as2lib.env.util.OutUtil;
import org.as2lib.core.BasicClass;

/**
 * TraceHandler is a concrete instance of the OutHandler interface. It uses #trace(String)
 * to write out the information. The Strings are generated from the OutWriteInfo with the
 * help of the OutUtil.stringifyWriteInfo(OutWriteInfo) operation or from the OurErrorInfo
 * with the OutUtil.stringifyErrorInfo(OutErrorInfo) operation. The Stringifiers used by
 * these two methods can be set in the OutConfig class.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.out.handler.TraceHandler extends BasicClass implements OutHandler {
	/**
	 * Uses #trace(String) to make the output. The String representation is obtained via
	 * the OutUtil.stringifyWriteInfo(OutWriteInfo) operation. You can modify the Stringifier
	 * used by this operation in the OutConfig class.
	 *
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function write(info:OutWriteInfo):Void {
		trace (OutUtil.stringifyWriteInfo(info));
	}
	
	/**
	 * Uses #trace(String) to make the output. The String representation is obtained via
	 * the OutUtil.stringifyErrorInfo(OutErrorInfo) operation. You can modify the Stringifier
	 * used by this operation in the OutConfig class.
	 *
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function error(info:OutErrorInfo):Void {
		trace (OutUtil.stringifyErrorInfo(info));
	}
}