import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.core.BasicClass;

class org.as2lib.data.holder.Stack extends BasicClass {
	private var target:Array;
	
	public function Stack(Void) {
		target = new Array();
	}
	
	public function push(object) {
		target.push(object);
		return object;
	}
	
	public function pop(Void) {
		return target.pop();
	}
	
	public function peek(Void) {
		return target[target.length - 1];
	}
	
	public function iterator(Void):Iterator {
		return (new ArrayIterator(target));
	}
	
	public function isEmpty() {
		return (target.length == 0);
	}
}