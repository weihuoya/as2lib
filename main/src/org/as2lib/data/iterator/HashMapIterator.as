import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.data.holder.HashMap;
import org.as2lib.core.BasicClass;

class org.as2lib.data.iterator.HashMapIterator extends BasicClass implements Iterator {
	private var target:HashMap;
	private var iterator:ArrayIterator;
	private var key;
	
	public function HashMapIterator(newTarget:HashMap) {
		target = newTarget;
		iterator = new ArrayIterator(target.getKeys());
	}
	
	public function hasNext(Void):Boolean {
		return iterator.hasNext();
	}
	
	public function next(Void) {
		key = iterator.next();
		return target.get(key);
	}
	
	public function remove(Void):Void {
		iterator.remove();
		target.remove(key);
	}
}