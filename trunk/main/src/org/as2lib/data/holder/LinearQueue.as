import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.data.holder.Queue;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.data.holder.HolderConfig;

/**
 * LinearQueue is an implementaion of the Queue interface. The LinearQueue stores
 * values in a linear manner.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.LinearQueue extends BasicClass implements Queue {
	/** Contains the inserted elements. */
	private var data:Array;
	
	/**
	 * Constructs a new LinearQueue.
	 */
	public function LinearQueue(Void) {
		data = new Array();
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#enqueue()
	 */
	public function enqueue(value):Void {
		data.push(value);
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#dequeue()
	 */
	public function dequeue(Void) {
		if (data.length == 0) {
			throw new EmptyDataHolderException("You tried to dequeue an element from an empty Queue.",
										  this,
										  arguments);
		}
		return data.shift();
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#peek()
	 */
	public function peek(Void) {
		if (data.length == 0) {
			throw new EmptyDataHolderException("You tried to peek an element from an empty Queue.",
										  this,
										  arguments);
		}
		return data[0];
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return (data.length == 0);
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#iterator()
	 */
	public function iterator(Void):Iterator {
		return (new ArrayIterator(data));
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return HolderConfig.getQueueStringifier().execute(this);
	}
}