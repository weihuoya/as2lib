import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.HolderConfig;
import org.as2lib.data.holder.Stack;
import org.as2lib.data.holder.EmptyDataHolderException;

/**
 * A simple implementation of the Stack interface.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.SimpleStack extends BasicClass implements Stack {
	/** Contains the inserted values. */
	private var target:Array;
	
	/**
	 * Constructs a new SimpleStack.
	 */
	public function SimpleStack(Void) {
		target = new Array();
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#push()
	 */
	public function push(value):Void {
		target.push(value);
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#pop()
	 */
	public function pop(Void) {
		if (target.length == 0) {
			throw new EmptyDataHolderException("You tried to pop an element from an empty Stack.",
										  this,
										  arguments);
		}
		return target.pop();
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#peek()
	 */
	public function peek(Void) {
		if (target.length == 0) {
			throw new EmptyDataHolderException("You tried to peek an element from an empty Stack.",
										  this,
										  arguments);
		}
		return target[target.length - 1];
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#iterator()
	 */
	public function iterator(Void):Iterator {
		return (new ArrayIterator(target));
	}
	
	/**
	 * @see org.as2lib.data.holder.Stack#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return (target.length == 0);
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return HolderConfig.getStackStringifier().execute(this);
	}
}