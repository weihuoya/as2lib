import org.as2lib.data.Iterator;
import org.as2lib.data.ArrayIterator;
import org.as2lib.data.Hashtable;

class org.as2lib.data.HashtableIterator implements Iterator {
	private var target:Hashtable;
	private var keyIterator:ArrayIterator;
	private var lastKey:String;
	
	public function HashtableIterator(newTarget:Hashtable) {
		target = newTarget;
		keyIterator = new ArrayIterator(target.getKeys());
	}
	
	public function hasNext(Void):Boolean {
		return keyIterator.hasNext();
	}
	public function next(Void):Object {
		lastKey = String(keyIterator.next());
		return target.get(lastKey);
	}
	public function remove(Void):Void {
		keyIterator.remove();
		target.remove(lastKey);
	}
}