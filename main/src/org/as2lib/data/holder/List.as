import org.as2lib.core.BasicInterface;
import org.as2lib.data.iterator.Iterator;

/**
 * @author Simon Wacker
 */
interface org.as2lib.data.holder.List extends BasicInterface {
	public function insert(value):Void;
	public function insertFirst(value):Void;
	public function insertLast(value):Void;
	public function insertAll(list:List):Void;
	
	public function remove();
	public function removeByValue(value):Void;
	public function removeByIndex(index:Number);
	
	public function removeFirst(Void);
	public function removeLast(Void);
	public function removeAll(list:List):Void;
	
	public function set(index:Number, value);
	public function setAll(index:Number, list:List):Void;
	
	public function get(index:Number);
	
	public function contains(value):Boolean;
	public function containsAll(list:List):Boolean;
	
	public function retainAll(list:List):Void;
	public function clear(Void):Void;
	public function size(Void):Number;
	public function isEmpty(Void):Boolean;
	public function iterator(Void):Iterator;
	public function indexOf(value):Number;
}