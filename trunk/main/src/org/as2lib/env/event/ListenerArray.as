import org.as2lib.core.BasicClass;
import org.as2lib.env.event.EventListener;
import org.as2lib.util.ArrayUtil;

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
		ArrayUtil.removeElement(listeners, listener);
	}
	
	public function clear(Void):Void {
		listeners = new Array();
	}
	
	public function get length():Number {
		return listeners.length;
	}
}