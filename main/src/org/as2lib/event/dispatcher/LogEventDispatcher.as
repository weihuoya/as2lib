import org.as2lib.event.EventInfo;
import org.as2lib.event.EventDispatcher;
import org.as2lib.event.Consumeable;
import org.as2lib.event.ListenerArray;
import org.as2lib.core.BasicClass;
import org.as2lib.event.EventConfig;

/**
 * @version 1.0
 */
class org.as2lib.event.dispatcher.LogEventDispatcher extends BasicClass implements EventDispatcher {
	/**
	 * @see org.as2lib.event.EventDispatcher
	 */
	public function dispatch(event:EventInfo, listeners:ListenerArray):Void {
		var name:String = event.getName();
		var l:Number = listeners.length;
		for (var i:Number = 0; i < l; i++) {
			EventConfig.getOut().log("Forwarding event #" + i + " with name " + name);
			listeners.get(i)[name](event);
		}
	}
	
	public function dispatchConsumeable(event:EventInfo, listeners:ListenerArray):Void {
		var name:String = event.getName();
		var l:Number = listeners.length;
		for (var i:Number = 0; i < l; i++) {
			EventConfig.getOut().log("Forwarding event #" + i + " with name " + name);
			listeners.get(i)[name](event);
			if (Consumeable(event).isConsumed()) {
				return;
			}
		}
	}
}
