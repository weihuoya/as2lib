import org.as2lib.basic.event.EventInfo;
import org.as2lib.basic.event.EventDispatcher;
import org.as2lib.basic.TypedArray;
import org.as2lib.basic.Out;

/**
 * @version 1.0
 */
class org.as2lib.basic.event.dispatcher.LogEventDispatcher implements EventDispatcher {
	/**
	 * @see org.as2lib.basic.event.EventDispatcher
	 */
	public function dispatch(event:EventInfo, listeners:TypedArray):Void {
		var name:String = event.getName();
		if (!event.isConsumed) {
			var l:Number = listeners.length;
			for (var i:Number = 0; i < l; i++) {
				//Out.write("Forwarding event #" + i + " with type " + type)
				listeners.getValue(i)[name](event);
			}
		}
	}
}
