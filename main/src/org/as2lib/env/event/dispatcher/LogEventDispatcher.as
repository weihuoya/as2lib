import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.EventDispatcher;
import org.as2lib.env.event.Consumeable;
import org.as2lib.env.event.ListenerArray;
import org.as2lib.core.BasicClass;
import org.as2lib.env.event.EventConfig;

/**
 * @version 1.0
 */
class org.as2lib.env.event.dispatcher.LogEventDispatcher extends BasicClass implements EventDispatcher {
	/**
	 * @see org.as2lib.env.event.EventDispatcher
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
