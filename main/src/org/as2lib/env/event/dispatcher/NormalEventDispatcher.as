import org.as2lib.env.event.EventInfo;
import org.as2lib.env.event.EventDispatcher;
import org.as2lib.env.event.Consumeable;
import org.as2lib.core.BasicClass;
import org.as2lib.env.event.ListenerArray;

/**
 * A normal implementation of the EventDispatcher interface.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.dispatcher.NormalEventDispatcher extends BasicClass implements EventDispatcher {
	/**
	 * @see org.as2lib.env.event.EventDispatcher#dispatch()
	 */
	public function dispatch(event:EventInfo, listeners:ListenerArray):Void {
		var name:String = event.getName();
		var l:Number = listeners.length;
		for (var i:Number = 0; i < l; i++) {
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
			listeners.get(i--)[name](event);
			if (Consumeable(event).isConsumed()) {
				return;
			}
		}
	}
}