import org.as2lib.basic.event.EventInfo;
import org.as2lib.basic.event.EventDispatcher;
import org.as2lib.basic.event.Consumeable;
import org.as2lib.basic.BasicClass;
import org.as2lib.basic.event.ListenerArray;

/**
 * @version 1.0
 */
class org.as2lib.basic.event.dispatcher.NormalEventDispatcher extends BasicClass implements EventDispatcher {
	/**
	 * @see org.as2lib.basic.event.EventDispatcher
	 */
	public function dispatch(event:EventInfo, listeners:ListenerArray):Void {
		var name:String = event.getName();
		var l:Number = listeners.length;
		for (var i:Number = 0; i < l; i++) {
			listeners.get(i)[name](event);
		}
	}
	
	public function dispatchConsumeable(event:EventInfo, listeners:ListenerArray):Void {
		var name:String = event.getName();
		var l:Number = listeners.length;
		for (var i:Number = 0; i < l; i++) {
			listeners.get(i)[name](event);
			if (Consumeable(event).isConsumed()) {
				return;
			}
		}
	}
}