import org.as2lib.basic.event.EventInfo;
import org.as2lib.basic.event.EventDispatcher;
import org.as2lib.basic.TypedArray;

/**
 * @version 1.0
 */
class org.as2lib.basic.event.dispatcher.NormalEventDispatcher implements EventDispatcher {
	/**
	 * @see org.as2lib.basic.event.EventDispatcher
	 */
	public function dispatch(event:EventInfo, listeners:TypedArray):Void {
		var type:String = event.getName();
		if (!event.isConsumed) {
			var l:Number = listeners.length;
			for (var i:Number = 0; i < l; i++) {
				listeners[i][type](event);
			}
		}
	}
}