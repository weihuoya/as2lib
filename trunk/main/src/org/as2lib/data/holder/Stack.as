import org.as2lib.data.iterator.Iterator;
import org.as2lib.core.BasicInterface;

/**
 * ?
 *
 * @author Simon Wacker
 */
interface org.as2lib.data.holder.Stack extends BasicInterface {
	/**
	 * Pushes the value to the Stack.
	 *
	 * @param value the value to be pushed to the Stack
	 */
	public function push(value):Void;
	
	/**
	 * Removes the lastly pushed value.
	 *
	 * @return the lastly pushed value
	 * @throws org.as2lib.data.holder.EmptyDataHolderException if the Stack is empty
	 */
	public function pop(Void);
	
	/**
	 * Returns the lastly pushed value.
	 *
	 * @return the lastly pushed value
	 * @throws org.as2lib.data.holder.EmptyDataHolderException if the Stack is empty
	 */
	public function peek(Void);
	
	/**
	 * Returns an Iterator used to iterate over the values of the Stack.
	 *
	 * @return an Iterator to iterate over the Stack
	 * @see org.as2lib.data.iterator.Iterator
	 */
	public function iterator(Void):Iterator;
	
	/**
	 * Returns whether the Stack is empty.
	 *
	 * @return true if the Stack is empty else false
	 */
	public function isEmpty(Void):Boolean;
}