import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.OutHandler;
import org.as2lib.env.out.OutInfo;
import org.as2lib.env.out.OutConfig;
import org.as2lib.core.BasicClass;
import mx.controls.Alert;

/** 
  * OutHandler to test the Implementation of Out.
  * 
  * @author Martin Heidegger
  */
class test.unit.org.as2lib.env.out.handler.TOutHandler extends BasicClass implements OutHandler {
	
	/** Holder for the last called info */
	private var lastInfo:OutInfo;

	/**
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function write(info:OutInfo):Void {
		lastInfo = info;
	}
	
	/**
	 * @return the message of the last called Info.
	 */
	public function getLastMessage(Void) {
		return lastInfo.getMessage();
	}
	
	/**
	 * @return the last called Info.
	 */
	public function getLastInfo(Void):OutInfo {
		return lastInfo;
	}
}