import org.as2lib.data.iterator.Iterator;
import org.as2lib.data.iterator.ArrayIterator;
import org.as2lib.data.holder.Queue;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.EmptyDataHolderException;
import org.as2lib.data.holder.HolderConfig;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * TypedQueue is used as a wrapper for Queues. It ensures that only values from
 * a specific type are added to the queue.
 *
 * @author Simon Wacker
 */
class org.as2lib.data.holder.TypedQueue extends BasicClass implements Queue {
	/** The Queue the TypedQueue wraps. */
	private var queue:Queue;
	
	/** The type of values that can be added. */
	private var type:Function;
	
	/**
	 * Constructs a new TypedQueue
	 *
	 * @param queue the queue to be wrapped
	 * @param type the type of values that are allowed to be added
	 */
	public function TypedQueue(queue:Queue, type:Function) {
		this.queue = queue;
		this.type = type;
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#enqueue()
	 * @throws org.as2lib.env.except.IllegalArgumentException if the type of the value is not valid
	 */
	public function enqueue(value):Void {
		validate(value);
		queue.enqueue(value);
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#dequeue()
	 */
	public function dequeue(Void) {
		return queue.dequeue();
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#peek()
	 */
	public function peek(Void) {
		return queue.peek();
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#isEmpty()
	 */
	public function isEmpty(Void):Boolean {
		return queue.isEmpty();
	}
	
	/**
	 * @see org.as2lib.data.holder.Queue#iterator()
	 */
	public function iterator(Void):Iterator {
		return queue.iterator();
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return queue.toString();
	}
	
	/**
	 * Validates the passed object based on its type.
	 *
	 * @param object the object which type shall be validated
	 * @throws org.as2lib.env.except.IllegalArgumentException if the type of the object is not valid
	 */
	private function validate(object):Void {
		if (!ObjectUtil.typesMatch(object, type)) {
			throw new IllegalArgumentException("Type mismatch between [" + object + "] and [" + type + "].");
		}
	}
}