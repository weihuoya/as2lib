import org.as2lib.data.iterator.Iterator;
import org.as2lib.core.BasicInterface;

/**
 * ?
 *
 * @author Simon Wacker
 */
interface org.as2lib.data.holder.Queue extends BasicInterface {
	/**
	 * Inserts the value into the queue.
	 *
	 * @param value the value to be inserted
	 */
	public function enqueue(value):Void;
	
	/**
	 * Removes the firstly inserted value.
	 *
	 * @return the firstly inserted value
	 * @throws org.as2lib.data.holder.EmptyDataHolderException if the Queue is empty
	 */
	public function dequeue(Void);
	
	/**
	 * Returns the firstly inserted value.
	 *
	 * @return the firstly inserted value
	 * @throws org.as2lib.data.holder.EmptyDataHolderException if the Queue is empty
	 */
	public function peek(Void);
	
	/**
	 * Returns whether the queue contains no values.
	 *
	 * @return true if the queue contains no values else false
	 */
	public function isEmpty(Void):Boolean;
	
	/**
	 * Returns an Iterator that can be used to iterate over the elements fo this
	 * Queue.
	 *
	 * @return an Iterator to iterate over this queue
	 * @see org.as2lib.data.iterator.Iterator
	 */
	public function iterator(Void):Iterator;
}