import org.as2lib.core.BasicClass;
import org.as2lib.env.event.EventListener;
import org.as2lib.env.except.IllegalArgumentException;

class org.as2lib.env.event.ListenerArray extends BasicClass {
	private var listeners:Array;
	
	public function ListenerArray(Void) {
		listeners = new Array();
	}
	
	public function set(listener:EventListener):Void {
		listeners.push(listener);
	}
	
	public function get(id:Number):EventListener {
		return listeners[id];
	}
	
	public function remove(listener:EventListener):Void {
		var l:Number = length;
		for (var i:Number = 0; i <= l; i++) {
			if (get(i) === listener) {
				listeners.splice(i, 1);
				return;
			}
		}
		throw new IllegalArgumentException("The specified listener [" + listener + "] is not available and could therefor not be removed.", 
											this,
											arguments);
	}
	
	public function clear(Void):Void {
		listeners = new Array();
	}
	
	public function get length():Number {
		return listeners.length;
	}
}