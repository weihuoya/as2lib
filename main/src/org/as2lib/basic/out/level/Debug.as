﻿import org.as2lib.basic.out.level.Info;
import org.as2lib.basic.out.info.OutWriteInfo;
import org.as2lib.event.EventBroadcaster;
import org.as2lib.event.EventInfo;
import org.as2lib.basic.out.Out;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.Debug extends Info {
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function debug(message:String, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutWriteInfo("write", message, Out.DEBUG);
		broadcaster.dispatch(event);
	}
}