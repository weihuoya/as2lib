import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.data.holder.Hashtable;

class org.as2lib.data.iterator.HashtableIterator implements Iterator {
	private var target:Hashtable;
	private var iterator:ArrayIterator;
	private var key:Object;
	
	public function HashtableIterator(newTarget:Hashtable) {
		target = newTarget;
		iterator = new ArrayIterator(target.getKeys());
	}
	
	public function hasNext(Void):Boolean {
		return iterator.hasNext();
	}
	
	public function next(Void):Object {
		key = iterator.next();
		return target.get(key);
	}
	
	public function remove(Void):Void {
		iterator.remove();
		target.remove(key);
	}
}