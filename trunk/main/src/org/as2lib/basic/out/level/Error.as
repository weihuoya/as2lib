﻿import org.as2lib.basic.out.level.Fatal;
import org.as2lib.basic.out.info.OutErrorInfo;
import org.as2lib.event.EventBroadcaster;
import org.as2lib.event.EventInfo;
import org.as2lib.basic.except.Throwable;
import org.as2lib.basic.out.Out;

/**
 * @author Martin Heidegger, Simon Wacker
 * @version 1.0
 */
class org.as2lib.basic.out.level.Error extends Fatal {
	/**
	 * @see org.as2lib.basic.out.OutLevel
	 */
	public function error(throwable:Throwable, broadcaster:EventBroadcaster):Void {
		var event:EventInfo = new OutErrorInfo("error", throwable, Out.ERROR);
		broadcaster.dispatch(event);
	}
}