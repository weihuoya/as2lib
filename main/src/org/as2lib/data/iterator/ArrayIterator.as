import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.NoSuchElementException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.core.BasicClass;

class org.as2lib.data.iterator.ArrayIterator extends BasicClass implements Iterator {
	private var target:Array;
	private var index:Number;
	
	public function ArrayIterator(newTarget:Array) {
		target = newTarget;
		index = -1;
	}
	
	public function hasNext(Void):Boolean {
		return (index < target.length - 1);
	}
	
	public function next(Void) {
		if (!hasNext()) {
			throw new NoSuchElementException("There is no more element.",
											 this,
											 arguments);
		}
		return target[++index];
	}
	
	public function remove(Void):Void {
		if (index == -1) {
			throw new IllegalStateException("You tried to remove an element before calling the #next() method. Thus there is no element selected to remove.",
											this,
											arguments);
		}
		target.splice(index--, 1);
	}
}