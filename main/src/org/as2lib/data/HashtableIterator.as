import org.as2lib.data.Iterator;
import org.as2lib.data.ArrayIterator;
import org.as2lib.data.Hashtable;

class org.as2lib.data.HashtableIterator implements Iterator {
	
	private var _target:Hashtable;
	private var _keyIterator:ArrayIterator;
	private var _lastKey:String;
	
	public function HashtableIterator(target:Hashtable) {
		_target = target;
		_keyIterator = new ArrayIterator(target.getKeys());
	}
	
	public function hasNext():Boolean {
		return _keyIterator.hasNext();
	}
	public function next():Object {
		_lastKey = String(_keyIterator.next());
		return _target.get(_lastKey);
	}
	public function remove():Void {
		_keyIterator.remove();
		_target.remove(_lastKey);
	}
}