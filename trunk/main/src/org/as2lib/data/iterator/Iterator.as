import org.as2lib.core.BasicInterface;

/**
 * Iterators are used to iterate over data holders.
 *
 * @author Michael Hermann
 * @author Simon Wacker
 */
interface org.as2lib.data.iterator.Iterator extends BasicInterface {
	/**
	 * Returns whether there exists another object to iterate over.
	 *
	 * @return true if there are objects left to iterate over
	 */
	public function hasNext(Void):Boolean;
	
	/**
	 * Returns the next object.
	 *
	 * @return the next object
	 * @throws org.as2lib.data.iterator.NoSuchElementException if there is no next element
	 */
	public function next(Void);
	
	/**
	 * Removes the presently selected object from the data holder the Iterator
	 * iterates over.
	 */
	public function remove(Void):Void;
}