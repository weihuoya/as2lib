import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.EventDispatcher;
import org.as2lib.env.event.Consumeable;
import org.as2lib.env.event.ListenerArray;
import org.as2lib.core.BasicClass;
import org.as2lib.env.event.EventConfig;

/**
 * An implementation of the EventDispatcher interface that logs the dispatching
 * of the event.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.dispatcher.LogEventDispatcher extends BasicClass implements EventDispatcher {
	/**
	 * @see org.as2lib.env.event.EventDispatcher#dispatch()
	 */
	public function dispatch(event:EventInfo, listeners:ListenerArray):Void {
		var name:String = event.getName();
		var l:Number = listeners.length;
		for (var i:Number = 0; i < l; i++) {
			EventConfig.getOut().log("Forwarding event #" + i + " with name " + name);
			listeners.get(i)[name](event);
		}
	}
	
	/**
	 * @see org.as2lib.env.event.EventDispatcher#dispatchConsumeable()
	 */
	public function dispatchConsumeable(event:EventInfo, listeners:ListenerArray):Void {
		var name:String = event.getName();
		var l:Number = listeners.length;
		for (var i:Number = l; i >= 0;) {
			EventConfig.getOut().log("Forwarding event #" + (i--) + " with name " + name);
			listeners.get(i)[name](event);
			if (Consumeable(event).isConsumed()) {
				return;
			}
		}
	}
}
