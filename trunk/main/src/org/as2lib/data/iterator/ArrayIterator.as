import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.NoSuchElementException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.core.BasicClass;

/**
 * ArrayIterator is used to iterate over an Array.
 *
 * @author Michael Hermann
 * @author Simon Wacker
 */
class org.as2lib.data.iterator.ArrayIterator extends BasicClass implements Iterator {
	/** The target data holder. */
	private var target:Array;
	
	/** The current index of the iteration. */
	private var index:Number;
	
	/**
	 * Constructs a new ArrayIterator.
	 *
	 * @param target the Array to iterate over
	 */
	public function ArrayIterator(newTarget:Array) {
		target = newTarget;
		index = -1;
	}
	
	/**
	 * @see org.as2lib.data.iterator.Iterator#hasNext()
	 */
	public function hasNext(Void):Boolean {
		return (index < target.length - 1);
	}
	
	/**
	 * @see org.as2lib.data.iterator.Iterator#next()
	 */
	public function next(Void) {
		if (!hasNext()) {
			throw new NoSuchElementException("There is no more element.",
											 this,
											 arguments);
		}
		return target[++index];
	}
	
	/**
	 * @see org.as2lib.data.iterator.Iterator#remove()
	 */
	public function remove(Void):Void {
		if (index == -1) {
			throw new IllegalStateException("You tried to remove an element before calling the #next() method. Thus there is no element selected to remove.",
											this,
											arguments);
		}
		target.splice(index--, 1);
	}
}